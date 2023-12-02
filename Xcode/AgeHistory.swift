// AgeHistory.swift
// Reportes Vistas

import SwiftUI
import Charts
import FirebaseFirestore

struct UserAgeModel: Identifiable {
    let id = UUID()
    let age: Int
    let userCount: Int
    let color: Color
    var animate: Bool = false
}

struct AgeHistory: View {
    @State private var ageList: [UserAgeModel] = []
    
    var body: some View {
        VStack {
            if ageList.isEmpty {
                Text("Recuperando datos...")
            } else {
                let max = ageList.max {
                    item1, item2 in return item2.userCount > item1.userCount
                }?.userCount ?? 0
                Chart(ageList) { userAgeModel in
                    BarMark(
                        x: .value("Edad", Double(userAgeModel.age)),
                        y: .value("Usuarios", userAgeModel.animate ? Double(userAgeModel.userCount) : 0)
                    )
                    .annotation(position: .top, alignment: .center) {
                        if userAgeModel.userCount != 0 {
                            Text("\(userAgeModel.userCount)")
                        }
                    }
                    .foregroundStyle(userAgeModel.color)
                }
                .chartXAxisLabel("Edades")
                .chartYAxisLabel("Cantidad de Usuarios")
                .chartYScale(domain: 0...(max + 10))
                .onAppear {
                    withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                        for (index, _) in ageList.enumerated(){
                            ageList[index].animate = true
                        }
                    }
                }
            }
        }
        .onAppear {
            fetchDataFromFirestore()
        }
    }
    
    func fetchDataFromFirestore() {
        let db = Firestore.firestore()
        let collection = db.collection("usuarios")

        // Array de colores para asignar a cada barra
        let colors: [Color] = [.red, .blue, .green, .orange, .purple, .pink, .yellow]

        // Array para almacenar recuentos para cada edad única
        var ageCounts: [Int: Int] = [:]

        collection.getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    if let ageString = document["edad"] as? String,
                       let age = Int(ageString) {
                        ageCounts[age, default: 0] += 1
                    }
                }

                // Asegurarse de tener datos para todas las edades de 0 a 100
                for age in 0...100 {
                    ageCounts[age, default: 0] += 0
                }

                // Convertir recuentos agregados de nuevo a UserAgeModel y asignar colores
                for (index, (age, userCount)) in ageCounts.sorted(by: { $0.key < $1.key }).enumerated() {
                    let colorIndex = index % colors.count
                    let model = UserAgeModel(age: age, userCount: userCount, color: colors[colorIndex])
                    ageList.append(model)
                }
            }
        }
    }
}

