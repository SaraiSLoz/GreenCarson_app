//
//  ResiduosViewController.swift
//  Reportes Vistas

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
        // Se utiliza el view respecto a su tag
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
        // Crear una alerta para solicitar permiso
        let alertController = UIAlertController(
            title: "Descargar Documento",
            message: "¿Estás seguro de que deseas descargar este documento?",
            preferredStyle: .alert
        )

        // Añadir acciones a la alerta
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))

        alertController.addAction(UIAlertAction(title: "Descargar", style: .default, handler: { [weak self] _ in
            // Procede con la descarga y guardado del documento
            self?.performSaveDocument()
        }))

        // Presentar la alerta
        present(alertController, animated: true, completion: nil)
    }

    func performSaveDocument() {
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
