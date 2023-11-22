// AgeHistory.swift
// Reportes Vistas
//
// Created by Diego Tomé Guardado on 16/11/23.
//
import SwiftUI
import Charts
import FirebaseFirestore

struct UserAgeModel: Identifiable {
    let id = UUID()
    let age: Int
    let userCount: Int
    let color: Color
}

struct AgeHistory: View {
    @State private var ageList: [UserAgeModel] = []

    var body: some View {
        VStack {
            if ageList.isEmpty {
                Text("Loading data...")
            } else {
                Chart(ageList) { userAgeModel in
                    BarMark(
                        x: .value("Edad", Double(userAgeModel.age)),
                        y: .value("Usuarios", Double(userAgeModel.userCount))
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
