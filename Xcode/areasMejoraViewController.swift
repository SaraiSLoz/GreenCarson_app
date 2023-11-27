//
//  areasMejoraViewController.swift
//  Reportes Vistas
//
//  Created by Diego Tomé Guardado on 08/11/23.
//

import UIKit
import SwiftUI
import Firebase
import Charts
import SnapKit

class areasMejoraViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        setupView()
    }

    func setupView() {
        // Obtén la referencia a ageHistoryView desde el Storyboard usando el tag
        guard let ageHistoryView = self.view.viewWithTag(1) else {
            return
        }

        let controller = UIHostingController(rootView: AgeHistory())
        guard let timeView = controller.view else {
            return
        }

        ageHistoryView.addSubview(timeView)

        timeView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-40)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().inset(25)
            make.height.equalTo(250)
        }
    }
    
}
