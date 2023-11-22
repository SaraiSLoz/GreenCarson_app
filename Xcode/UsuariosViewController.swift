//
//  UsuariosViewController.swift
//  Reportes Vistas
//
//  Created by Diego Tomé Guardado on 08/11/23.
//

import UIKit
import SwiftUI
import SnapKit

class UsuariosViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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


}
