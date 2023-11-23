//
//  ResiduosViewController.swift
//  Reportes Vistas
//
//  Created by Diego Tomé Guardado on 08/11/23.
//

import UIKit
import SnapKit
import SwiftUI

class ResiduosViewController: UIViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // Funcion para colocar grafica en pantalla
    func setupView(){
            let controller = UIHostingController(rootView: MaterialsChart())
            guard let timeView = controller.view else {
                return
            }
            
            view.addSubview(timeView)
            
            timeView.snp.makeConstraints{ make in
                make.centerY.equalToSuperview().offset(80)
                make.leading.equalToSuperview().offset(25)
                make.trailing.equalToSuperview().inset(25)
                make.height.equalTo(500)
            }
        }
}
