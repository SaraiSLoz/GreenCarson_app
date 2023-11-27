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
        fetchDataAndSetupChart()
    }
    
    func setupView(){
            let controller = UIHostingController(rootView: AgeHistory())
            guard let timeView = controller.view else {
                return
            }
            
            view.addSubview(timeView)
            
            timeView.snp.makeConstraints{ make in
                make.centerY.equalToSuperview().offset(-40)
                make.leading.equalToSuperview().offset(25)
                make.trailing.equalToSuperview().inset(25)
                make.height.equalTo(250)
            }
        }
    
    // Funcion para colocar grafica de dona en pantalla
    func fetchDataAndSetupChart() {
            // Realizar una consulta a Firestore para obtener datos
            db.collection("usuarios").getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }

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

                // Añadir la vista del gráfico como una subvista
                self.view.addSubview(doughnutChart)

                // Establecer las restricciones para la vista del gráfico
                doughnutChart.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    doughnutChart.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 250),
                    doughnutChart.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
                    doughnutChart.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
                    doughnutChart.heightAnchor.constraint(equalToConstant: 250)
                ])
            }
        }


}
