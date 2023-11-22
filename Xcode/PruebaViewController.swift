//
//  PruebaViewController.swift
//  Reportes Vistas
//
//  Created by Diego Tomé Guardado on 15/11/23.
//

import UIKit
import Firebase
import Charts

class PruebaViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Llama a la función para cargar los datos y actualizar el gráfico
        cargarDatosYActualizarGrafico()
    }

    func cargarDatosYActualizarGrafico() {
        let db = Firestore.firestore()
        let recoleccionesCollection = db.collection("recolecciones")

        // Obtener las recolecciones desde Firestore
        recoleccionesCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No hay documentos.")
                return
            }

            // Crear un diccionario para almacenar la cuenta de recolecciones por hora
            var recoleccionesPorHora: [String: Int] = [:]

            // Iterar sobre los documentos y contar las recolecciones por hora
            for document in documents {
                if let hora = document["hora"] as? String {
                    // Extraer la hora del formato HH:mm:ss
                    let components = hora.components(separatedBy: ":")
                    if let horaDelDia = components.first {
                        // Incrementar la cuenta para esa hora
                        recoleccionesPorHora[horaDelDia, default: 0] += 1
                    }
                }
            }

            // Convertir el diccionario en datos para el gráfico
            let horas = Array(recoleccionesPorHora.keys)
            let counts = Array(recoleccionesPorHora.values)

            // Llamar a la función para actualizar el gráfico
            self.actualizarGrafico(horas: horas, counts: counts)
        }
    }

    func actualizarGrafico(horas: [String], counts: [Int]) {
        // Configurar el conjunto de datos para el gráfico de barras
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<horas.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(counts[i]))
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Recolecciones por hora")
        let chartData = BarChartData(dataSet: chartDataSet)

        // Configurar el eje X con las horas
        let chartFormatter = BarChartFormatter(values: horas)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        barChartView.xAxis.valueFormatter = xAxis.valueFormatter

        // Configurar el gráfico
        barChartView.data = chartData
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
}

// Clase para formatear el eje X del gráfico
class BarChartFormatter: NSObject, IAxisValueFormatter {
    var values: [String] = []

    init(values: [String]) {
        self.values = values
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        if index >= 0, index < values.count {
            return values[index]
        }
        return ""
    }
}
