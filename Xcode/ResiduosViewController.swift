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

        // Crea un renderizador de imágenes
        let renderer = UIGraphicsImageRenderer(bounds: targetView.bounds)

        // Renderiza la vista en una imagen
        let image = renderer.image { context in
            targetView.layer.render(in: context.cgContext)
        }

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
