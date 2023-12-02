//
//  Perfil1ViewController.swift
//  Reportes Vistas


import UIKit
import Firebase
import FirebaseAuth

class Perfil1ViewController: UIViewController {
    
    @IBOutlet weak var lineado: UITextField!
    @IBOutlet weak var lineado2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        
        // Llama a la función para agregar el subrayado al UITextField
        addBottomLineToTextField(textField: lineado)
        addBottomLineToTextField(textField: lineado2)
        // Llama a la función para obtener el apellido desde Firestore y actualizar lineado
        obtenerNombreYActualizarLineado()
        obtenerCorreoYActualizarLineado()
    }
    
    
    func addBottomLineToTextField(textField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 1, width: textField.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor // Puedes cambiar el color de la línea aquí
        
        textField.borderStyle = .none
        textField.layer.addSublayer(bottomLine)
    }
    

    func obtenerNombreYActualizarLineado() {
        // Verificar si hay un usuario autenticado
        if let user = Auth.auth().currentUser {
            let db = Firestore.firestore()
            let usuarioDocRef = db.collection("administradores").document(user.uid)
            
            // Datos del documento del usuario
            usuarioDocRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    // Campo "nombre"
                    if let nombre = document.data()?["nombre"] as? String {
                        // Campo "apellidos"
                        if let apellidos = document.data()?["apellidos"] as? String {
                            // Concatenar nombre y apellidos
                            let nombreCompleto = "\(nombre) \(apellidos)"
                            
                            // Actualiza el campo lineado con el valor del nombre completo
                            self.lineado.text = nombreCompleto
                        }
                    }
                }
            }
        } else {
            // No hay usuario autenticado, manejar según sea necesario
            print("No hay usuario autenticado.")
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
                
                // Eliminar el estado de la sesión guardado
                self.removeSessionState()
                
                // Redirigir a la página principal o a la pantalla de inicio de sesión
                self.performSegue(withIdentifier: "mainPage", sender: self)
                
            } catch let error as NSError {
                print("Error al cerrar sesión: \(error.localizedDescription)")
            }
        }
        alertController.addAction(confirmAction)
        
        // Presentar la alerta
        present(alertController, animated: true, completion: nil)
    }

    // Función para eliminar el estado de la sesión guardado
    private func removeSessionState() {
        UserDefaults.standard.removeObject(forKey: "isUserLoggedIn")
    }
}
