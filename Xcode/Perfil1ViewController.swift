//
//  Perfil1ViewController.swift
//  Reportes Vistas
//
//  Created by Diego Tomé Guardado on 09/10/23.
//

import UIKit
import Firebase
import FirebaseAuth

class Perfil1ViewController: UIViewController {
    
    @IBOutlet weak var lineado: UITextField!
    
    
    @IBOutlet weak var lineado2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Llama a la función para agregar el subrayado al UITextField
        addBottomLineToTextField(textField: lineado)
        addBottomLineToTextField(textField: lineado2)
        // Llama a la función para obtener el apellido desde Firestore y actualizar lineado
        obtenerApellidoYActualizarLineado()
        obtenerCorreoYActualizarLineado()
    }
    
    func addBottomLineToTextField(textField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 1, width: textField.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor // Puedes cambiar el color de la línea aquí
        
        textField.borderStyle = .none
        textField.layer.addSublayer(bottomLine)
    }
    

    func obtenerApellidoYActualizarLineado() {
        let db = Firestore.firestore()
        let administradorDocRef = db.collection("administradores").document("3L8PUgFO0VZyMt9qjzBmkRIhCsU2")
        
        // Datos del documento
        administradorDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Campo "apellidos"
                if let apellidos = document.data()?["apellidos"] as? String {
                    // Actualiza el campo lineado con el valor de "apellidos"
                    self.lineado.text = apellidos
                }
            }
        }
    }
    
    func obtenerCorreoYActualizarLineado() {
        // Verificar si hay un usuario autenticado
        if let user = Auth.auth().currentUser {
            // Obtener el correo electrónico del usuario
            let correoElectronico = user.email

            // Actualizar el campo lineado con el valor del correo electrónico
            self.lineado2.text = correoElectronico
        } else {
            // No hay usuario autenticado, manejar según sea necesario (por ejemplo, redirigir a la pantalla de inicio de sesión)
            print("No hay usuario autenticado.")
        }
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        // Crear una alerta de confirmación
         let alertController = UIAlertController(title: "Cerrar Sesión", message: "¿Estás seguro de que deseas cerrar sesión?", preferredStyle: .alert)
         
         // Añadir acciones a la alerta
         let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
         alertController.addAction(cancelAction)
         
         let confirmAction = UIAlertAction(title: "Cerrar Sesión", style: .destructive) { (_) in
             // Cerrar sesión en Firebase
             do {
                 try Auth.auth().signOut()
                 
                 self.performSegue(withIdentifier: "mainPage", sender: self)
                 
             } catch let error as NSError {
                 print("Error al cerrar sesión: \(error.localizedDescription)")
             }
         }
         alertController.addAction(confirmAction)
         
         // Presentar la alerta
         present(alertController, animated: true, completion: nil)
     }
}
