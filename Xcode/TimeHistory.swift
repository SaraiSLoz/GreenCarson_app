//  TimeHistory.swift
//  Reportes Vistas
//
//  Created by Diego Tomé Guardado on 16/11/23.
//
import SwiftUI
import Charts
import FirebaseFirestore

struct SavingsModel: Identifiable {
    let id = UUID()
    let hour: Date
    let recolectionCount: Int
}
struct TimeHistory: View {
    @State private var list: [SavingsModel] = []

    static var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df
    }()
    
    var body: some View {
        VStack {
            if list.isEmpty {
                Text("Loading data...")
            } else {
                Chart(list) { savingModel in
                    BarMark(
                        x: .value("Hour", savingModel.hour),
                        y: .value("Recolections", Double(savingModel.recolectionCount))
                    ).foregroundStyle(.red)
                }
            }
        }
        .onAppear {
            fetchDataFromFirestore()
        }
    }

    func fetchDataFromFirestore() {
        let db = Firestore.firestore()
        let collection = db.collection("recolecciones")

        // Dictionary to store counts for each unique hour
        var hourCounts: [String: Int] = [:]

        collection.getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    if let horaRecoleccionInicio = document["horaRecoleccionInicio"] as? String {
                        // Use only the first two characters of the hour string for grouping
                        let hourKey = String(horaRecoleccionInicio.prefix(2))
                        hourCounts[hourKey, default: 0] += 1
                    }
                }

                // Convert aggregated counts back to SavingsModel
                for (hour, recolectionCount) in hourCounts {
                    if let date = parseDate(from: hour + ":00") {
                        let model = SavingsModel(hour: date, recolectionCount: recolectionCount)
                        list.append(model)
                    }
                }
            }
        }
    }

    func parseDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.date(from: dateString)
    }
}
