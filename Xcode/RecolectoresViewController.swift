//
//  RecolectoresViewController.swift
//  Reportes Vistas
//
//  Created by Diego Tomé Guardado on 08/11/23.
//

import UIKit
import SwiftUI
import Firebase
import Charts
import SnapKit

class RecolectoresViewController: UIViewController {
    
    @IBOutlet weak var recolectoresServicio: UILabel!
    @IBOutlet weak var numRecolectores: UILabel!
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
            
        setupView()
        setupView2()
        showCollectors()
        showCollectorsInService()
    }
    
    // Funcion para colocar grafica en pantalla
    func setupView(){
        
        // Se utiliza el view respecto a su tag
        guard let chartView = self.view.viewWithTag(2) else {
            return
        }
        
        let controller = UIHostingController(rootView: TimeHistory())
        guard let timeView = controller.view else {
            return
        }
        
        chartView.addSubview(timeView)
        
        timeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupView2(){
        // Se utiliza el view respecto a su tag
        guard let chartContainerView = self.view.viewWithTag(1) else {
            return
        }

        // Tu código para obtener datos de Firestore y crear el gráfico
        db.collection("recolectores").getDocuments { [weak self] (snapshot, error) in
            guard self != nil else { return }

            if let error = error {
                print("Error al obtener datos de Firestore: \(error)")
                return
            }

            // Procesar los datos de la consulta
            var activeCount = 0
            var inactiveCount = 0

            for document in snapshot?.documents ?? [] {
                if let status = document["status"] as? Int {
                    if status == 1 {
                        activeCount += 1
                    } else if status == 0 {
                        inactiveCount += 1
                    }
                }
            }

            // Crear la vista del gráfico con los datos obtenidos
            let doughnutChart = DoughnutChartView(data: [
                "Usuarios activos": activeCount,
                "Usuarios inactivos": inactiveCount
            ])

            // Añadir la vista del gráfico al chartContainerView
            chartContainerView.addSubview(doughnutChart)

            // Establecer las restricciones para la vista del gráfico usando SnapKit
            doughnutChart.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    // Funcion para mostrar el numero de recolectores en total
    func showCollectors() {
        let db = Firestore.firestore()
        let collectorsCollection = db.collection("recolectores")
        
        collectorsCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            //obtiene el total de documentos en la coleccion
            let numDocs = querySnapshot?.documents.count ?? 0
            //actualiza el texto con el total de recolectores
            self.numRecolectores.text = "\(numDocs)"
        }
    }
    
    // Funcion para mostrar el numero de recolectores en servicio
    // Calculados por medio de su ultima recoleccion registrada
    func showCollectorsInService() {
        let db = Firestore.firestore()
        let collectorsCollection = db.collection("recolecciones")

        // Obtener la fecha actual
        let currentDate = Date()

        // Crear un formateador de fecha para manejar las fechas en formato dd/MM/yyyy
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        // Obtener el primer día y el último día del mes actual
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentDate)

        guard let startOfMonth = calendar.date(from: components),
              let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) else {
            return
        }

        // Convertir las fechas a cadenas para la comparación
        _ = dateFormatter.string(from: startOfMonth)
        _ = dateFormatter.string(from: endOfMonth)

        // Conjunto para almacenar nombres únicos de recolectores
        var uniqueCollectorNames = Set<String>()

        // Realizar la consulta en Firestore para todas las recolecciones
        collectorsCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            // Filtrar localmente las recolecciones del mes actual
            querySnapshot?.documents.forEach { document in
                guard let fechaRecoleccionString = document["fechaRecoleccion"] as? String,
                      let recolector = document["recolector"] as? [String: Any],
                      let nombreRecolector = recolector["nombre"] as? String else {
                    return
                }

                if let fechaRecoleccion = dateFormatter.date(from: fechaRecoleccionString),
                   fechaRecoleccion >= startOfMonth,
                   fechaRecoleccion <= endOfMonth {
                    // Agregar el nombre del recolector al conjunto
                    uniqueCollectorNames.insert(nombreRecolector)
                }
            }

            // Obtener el número de ids únicos de recolectores
            let numUniqueCollectorNames = uniqueCollectorNames.count

            // Actualizar el texto con el total de recolectores únicos
            DispatchQueue.main.async {
                self.recolectoresServicio.text = "\(numUniqueCollectorNames)"
            }
        }
    }

    func convertViewToImage(tag: Int) -> UIImage? {
        // Encuentra la vista con el tag proporcionado
        guard let targetView = self.view.viewWithTag(tag) else {
            print("No se encontró una vista con el tag \(tag)")
            return nil
        }

        // Crea un contexto de gráficos
        UIGraphicsBeginImageContextWithOptions(targetView.bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Error al obtener el contexto de gráficos.")
            return nil
        }

        // Renderiza la vista en el contexto de gráficos
        targetView.layer.render(in: context)

        // Obtiene la imagen del contexto de gráficos
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            print("Error al obtener la imagen del contexto de gráficos.")
            UIGraphicsEndImageContext()
            return nil
        }

        // Finaliza el contexto de gráficos
        UIGraphicsEndImageContext()

        return image
    }

    // Funcion para crear un documento PDF
    @IBAction func saveDocumento(_ sender: Any) {
        // Obtén la fecha actual
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: currentDate)
        guard let image =  convertViewToImage(tag: 1) else { return }

        let pdfCreator = PDFCreator(
            title: "Materiales",
            body: "Fecha de descarga: \(dateString)",
            images: [image],
            contact: ""
        )
        let pdfData = pdfCreator.createFlyer()
        let vc = UIActivityViewController(
            activityItems: [pdfData],
            applicationActivities: []
        )
        present(vc, animated: true, completion: nil)
    }
    
}
