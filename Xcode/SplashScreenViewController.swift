import UIKit

class SplashScreenViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        addImageView()
        addTextLabel()
        addTitle()
        // Simular una carga de 2 segundos y luego pasar a la pantalla principal
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.checkSessionStateAndNavigate()
            self.dismiss(animated: true, completion: nil)
        }
    }


    private func checkSessionStateAndNavigate() {
        if self.loadSessionState() {
            // Si el usuario está autenticado, ir directamente a la siguiente vista
            self.performSegue(withIdentifier: "init", sender: self)
        } else {
            // Si el usuario no está autenticado, ir a la pantalla de inicio de sesión
            self.performSegue(withIdentifier: "log", sender: self)
        }
    }

    private func loadSessionState() -> Bool {
        return UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    }
    
    
    func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 71/255, green: 186/255, blue: 108/255, alpha: 1).cgColor,
            UIColor(red: 10/255, green: 185/255, blue: 156/255, alpha: 1).cgColor,
            UIColor(red: 68/255, green: 137/255, blue: 202/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    func addImageView() {
        let imageView = UIImageView(image: UIImage(named: "Logo_final-removebg-preview"))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        imageView.center = view.center
        view.addSubview(imageView)
    }

    func addTitle() {
        let largeLabel = UILabel()
        largeLabel.text = "Reeportes"
        largeLabel.textColor = .white
        largeLabel.font = UIFont.boldSystemFont(ofSize: 24)
        largeLabel.textAlignment = .center
        largeLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width - 40, height: 80)
        largeLabel.center = CGPoint(x: view.center.x, y: view.center.y + 80)
        view.addSubview(largeLabel)
    }
    
    func addTextLabel() {
        let label = UILabel()
        label.text = "By 3BIT"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 0, width: view.frame.width - 40, height: 50)
        label.center = CGPoint(x: view.center.x, y: view.center.y + 120)
        view.addSubview(label)
    }
}
