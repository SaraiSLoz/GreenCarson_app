//
//  Perfil2ViewController.swift
//  Reportes Vistas
//
//  Created by Diego Tomé Guardado on 09/10/23.
//

import UIKit
import FirebaseAuth

class Perfil2ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lineado3: UITextField!
    

    @IBOutlet weak var lineado4: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        lineado3.delegate = self
        lineado4.delegate = self
        
        // Llama a la función para agregar el subrayado al UITextField
        addBottomLineToTextField(textField: lineado3)
        
        addBottomLineToTextField(textField: lineado4)

        lineado3.returnKeyType = .next

        lineado4.returnKeyType = .go
        
        lineado3.isSecureTextEntry = true
        lineado4.isSecureTextEntry = true

    }
    
    func addBottomLineToTextField(textField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 1, width: textField.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor // Puedes cambiar el color de la línea aquí

        textField.borderStyle = .none
        textField.layer.addSublayer(bottomLine)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == lineado3 {
                // If "Return" is pressed in lineado3, move to the next field
                lineado4.becomeFirstResponder()
            } else if textField == lineado4 {
                // If "Return" is pressed in lineado4, hide the keyboard and perform the button action
                textField.resignFirstResponder()
                changePassword(self)
            }

            return true
        }
    
    @IBAction func changePassword(_ sender: Any) {
        // Crear una alerta de confirmación
        let confirmAlert = UIAlertController(title: "Confirmar", message: "¿Está seguro de que desea cambiar la contraseña?", preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        confirmAlert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { _ in
            // El usuario ha confirmado cambiar la contraseña

            guard let currentPassword = self.lineado3.text, !currentPassword.isEmpty else {
                // Muestra un popup de aviso de contraseña actual vacía
                self.showAlert(message: "Ingrese su contraseña actual.")
                return
            }

            guard let newPassword = self.lineado4.text, !newPassword.isEmpty else {
                // Muestra un popup de aviso de nueva contraseña vacía
                self.showAlert(message: "Ingrese su nueva contraseña.")
                return
            }

            // Verifica la contraseña actual
            let user = Auth.auth().currentUser
            let credential = EmailAuthProvider.credential(withEmail: user?.email ?? "", password: currentPassword)

            user?.reauthenticate(with: credential) { _, error in
                if let error = error {
                    // Muestra un popup de aviso de contraseña actual incorrecta
                    self.showAlert(message: "Contraseña actual incorrecta. Inténtelo de nuevo.")
                } else {
                    // Verifica la longitud de la nueva contraseña
                    if newPassword.count < 5 {
                        // Muestra un popup de aviso de contraseña muy corta
                        self.showAlert(message: "La nueva contraseña debe tener al menos 5 caracteres.")
                    } else {
                        // Cambia la contraseña
                        user?.updatePassword(to: newPassword) { error in
                            if let error = error {
                                // Muestra un popup de aviso de error al cambiar la contraseña
                                self.showAlert(message: "Error al cambiar la contraseña. Inténtelo de nuevo.")
                            } else {
                                // Muestra un popup de confirmación
                                self.showAlert(message: "Contraseña cambiada exitosamente.")
                                self.lineado3.text = ""
                                self.lineado4.text = ""
                            }
                        }
                    }
                }
            }
        }))

        // Presentar la alerta de confirmación
        present(confirmAlert, animated: true, completion: nil)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Aviso", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
