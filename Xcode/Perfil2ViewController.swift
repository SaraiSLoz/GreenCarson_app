//
//  Perfil2ViewController.swift
//  Reportes Vistas
//
//  Created by Diego Tomé Guardado on 09/10/23.
//

import UIKit

class Perfil2ViewController: UIViewController {
    
    @IBOutlet weak var lineado3: UITextField!
    

    @IBOutlet weak var lineado4: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        
        // Llama a la función para agregar el subrayado al UITextField
        addBottomLineToTextField(textField: lineado3)
        
        addBottomLineToTextField(textField: lineado4)
    }
    
    func addBottomLineToTextField(textField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 1, width: textField.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor // Puedes cambiar el color de la línea aquí

        textField.borderStyle = .none
        textField.layer.addSublayer(bottomLine)
    }

}
