//
//  UsuariosViewController.swift
//  Reportes Vistas
//
//  Created by Diego Tomé Guardado on 08/11/23.
//

import UIKit
import SwiftUI
import SnapKit
import FirebaseFirestore

class UsuariosViewController: UIViewController {
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        
        setupView()
        setupView2()
    }
    
    func setupView(){
        
        // Se utiliza el view respecto a su tag
        guard let chartView = self.view.viewWithTag(1) else {
            return
        }
        
        let controller = UIHostingController(rootView: AgeHistory())
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
        guard let chartContainerView = self.view.viewWithTag(2) else {
            return
        }

        // Tu código para obtener datos de Firestore y crear el gráfico
        db.collection("usuarios").getDocuments { [weak self] (snapshot, error) in
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
    @IBAction func saveDocument(_ sender: Any) {
        // Obtén la fecha actual
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: currentDate)
        guard let image =  convertViewToImage(tag: 1) else { return }
        guard let image2 =  convertViewToImage(tag: 2) else { return }

        let pdfCreator = PDFCreator(
            title: "Usuarios",
            body: "Fecha de descarga: \(dateString)",
            images: [image, image2],
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


