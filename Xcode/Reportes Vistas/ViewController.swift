//
//  ViewController.swift
//  Reportes Vistas
//
//  Created by Diego Tomé Guardado on 01/10/23.
//

import UIKit
import Firebase
import Foundation
import FirebaseAuth
import FirebaseCore

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var password: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)

        // Do any additional setup after loading the view.
        password.delegate = self
        password.isSecureTextEntry = true
    }
    
    @IBAction func loginFun(_ sender: Any) {
        guard let emailUser = user.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                let passUser = password.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                        showToast(message: "Ingresa los datos")
                        return
                }

                if emailUser.isEmpty || passUser.isEmpty {
                    showToast(message: "Ingresa los datos")
                } else {
                    loginUserWithEmailAndPassword(email: emailUser, password: passUser)
                }
    }
    
    private func loginUserWithEmailAndPassword(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }

            if let error = error {
                self.showToast(message: "Inicio de sesión fallido: \(error.localizedDescription)")
            } else {
                // Inicio de sesión exitoso
                if let user = Auth.auth().currentUser {
                    // El usuario está autenticado, puedes pasar a la siguiente vista o realizar otras acciones
                    self.performSegue(withIdentifier: "loginSeg", sender: self)
                }
            }
        }
    }

    private func showToast(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
