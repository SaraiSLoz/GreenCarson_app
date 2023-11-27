//
//  ResiduosViewController.swift
//  Reportes Vistas
//
//  Created by Diego Tomé Guardado on 08/11/23.
//

import UIKit
import SnapKit
import SwiftUI
import PDFKit

class ResiduosViewController: UIViewController  {
    var pdfUrl : URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        
        setupView()
    }
    
    // Funcion para colocar grafica en pantalla
    func setupView() {
        // Obtén la referencia a MaterialsChartView desde el Storyboard usando el tag
        guard let materialsChartView = self.view.viewWithTag(1) else {
            return
        }
        
        let controller = UIHostingController(rootView: MaterialsChart())
        guard let timeView = controller.view else {
            return
        }
        
        materialsChartView.addSubview(timeView)
        
        timeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
            image: image,
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
