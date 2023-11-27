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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
            
        setupView()
        showCollectors()
        showCollectorsInService()
    }
    
    // Funcion para colocar grafica en pantalla
    func setupView(){
            let controller = UIHostingController(rootView: TimeHistory())
            guard let timeView = controller.view else {
                return
            }
            
            view.addSubview(timeView)
            
            timeView.snp.makeConstraints{ make in
                make.centerY.equalToSuperview().offset(300)
                make.leading.equalToSuperview().offset(25)
                make.trailing.equalToSuperview().inset(25)
                make.height.equalTo(250)
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
        let startOfMonthString = dateFormatter.string(from: startOfMonth)
        let endOfMonthString = dateFormatter.string(from: endOfMonth)

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


}
