import SwiftUI
import Charts
import FirebaseFirestore

struct CenterCategoryModel: Identifiable {
    let id = UUID()
    let category: String
    let centerCount: Int
    let color: Color
    var animate: Bool = false
}

struct CategoryHistory: View {
    @State private var categoryList: [CenterCategoryModel] = []
    
    var body: some View {
        VStack {
            if categoryList.isEmpty {
                Text("Recuperando datos...")
            } else {
                let max = categoryList.max {
                    item1, item2 in return item2.centerCount > item1.centerCount
                }?.centerCount ?? 0
                Chart(categoryList) { centerCategoryModel in
                    BarMark(
                        x: .value("Centros", centerCategoryModel.animate ? Double(centerCategoryModel.centerCount) : 0),
                        y: .value("Categoría", centerCategoryModel.category)
                    )
                    .annotation(position: .trailing, alignment: .center) {
                        if centerCategoryModel.centerCount != 0 {
                            Text("\(centerCategoryModel.centerCount)")
                            
                                .rotationEffect(Angle(degrees: 90), anchor: .center)
                            
                        }
                    }
                    
                    .foregroundStyle(centerCategoryModel.color)
                }
                .onAppear {
                    withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                        for (index, _) in categoryList.enumerated(){
                            categoryList[index].animate = true
                        }
                    }
                }
                .rotationEffect(Angle(degrees: -90), anchor: .center) 
            }
        }
        .onAppear {
            fetchDataFromFirestore()
        }
    }
    
    func fetchDataFromFirestore() {
        let db = Firestore.firestore()
        let collection = db.collection("centros")

        // Array de colores para asignar a cada barra
        let colors: [Color] = [.red, .blue, .green, .orange, .purple, .pink, .yellow]

        // Diccionario para almacenar recuentos para cada categoría única
        var categoryCounts: [String: Int] = [:]

        collection.getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    if let category = document["categoria"] as? String {
                        categoryCounts[category, default: 0] += 1
                    }
                }

                // Convertir recuentos agregados de nuevo a CenterCategoryModel y asignar colores
                for (index, (category, centerCount)) in categoryCounts.sorted(by: { $0.key < $1.key }).enumerated() {
                    let colorIndex = index % colors.count
                    let model = CenterCategoryModel(category: category, centerCount: centerCount, color: colors[colorIndex])
                    categoryList.append(model)
                }
            }
        }
    }
}
