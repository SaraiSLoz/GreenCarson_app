//
//  ViewController.swift
//  Reportes Vistas

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var password: UITextField!
    let backgroundImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        self.navigationItem.setHidesBackButton(true, animated: false)

        // Verificar el estado de la sesión al cargar la vista
        if loadSessionState() {
            // Si el usuario está autenticado, ir directamente a la siguiente vista
            self.performSegue(withIdentifier: "loginSeg", sender: self)
        }

        user.returnKeyType = .next
        user.delegate = self
        password.returnKeyType = .go
        password.delegate = self

        user.keyboardType = .emailAddress
        user.autocorrectionType = .no
        
        password.isSecureTextEntry = true
    }

    func addGradient() {
        // Crear la capa de gradiente
        let gradientLayer = CAGradientLayer()

        // Definir los colores del gradiente
        gradientLayer.colors = [
            UIColor(red: 71/255, green: 186/255, blue: 108/255, alpha: 1).cgColor,
            UIColor(red: 10/255, green: 185/255, blue: 156/255, alpha: 1).cgColor,
            UIColor(red: 68/255, green: 137/255, blue: 202/255, alpha: 1).cgColor
        ]

        // Definir la dirección del gradiente
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        gradientLayer.frame = CGRect(x: 0, y: view.bounds.height * 0.135, width: view.bounds.width, height: view.bounds.height * 0.65)

        // Insertar el gradiente como la primera capa de la vista
        view.layer.insertSublayer(gradientLayer, at: 1)
    }

    @IBAction func loginFun(_ sender: Any) {
        loginUser()
    }

    private func loginUser() {
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

        // Ocultar el teclado
        view.endEditing(true)
    }

    private func loginUserWithEmailAndPassword(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }

            if let error = error {
                self.showToast(message: "Correo o contraseña incorrectos: \(error.localizedDescription)")
            } else {
                // Successful login
                if let user = Auth.auth().currentUser {
                    // Check if the user is also an administrator
                    self.checkIfUserIsAdministrator(userId: user.uid)
                }
            }
        }
    }

    private func checkIfUserIsAdministrator(userId: String) {
        let db = Firestore.firestore()
        
        db.collection("administradores").document(userId).getDocument { [weak self] (document, error) in
            guard let self = self else { return }

            if let document = document, document.exists {
                self.saveSessionState()
                self.performSegue(withIdentifier: "loginSeg", sender: self)
            } else {
                self.showPermissionDeniedPopup()
            }
        }
    }

    private func showPermissionDeniedPopup() {
        print("No tienes permiso para acceder")
        let alertController = UIAlertController(title: "Acceso denegado", message: "No tienes permisos para acceder", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }


    private func showToast(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func saveSessionState() {
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
    }

    private func loadSessionState() -> Bool {
        return UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    }

    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == user {
            // Si se presiona "Siguiente" en el campo de usuario, pasar al campo de contraseña
            password.becomeFirstResponder()
        } else if textField == password {
            // Si se presiona "Iniciar sesión" en el campo de contraseña, ejecutar la acción de inicio de sesión
            loginUser()
        }

        return true
    }
}
