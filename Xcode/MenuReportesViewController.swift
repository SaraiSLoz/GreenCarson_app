//
//  MenuReportesViewController.swift
//  Reportes Vistas
//
//  Created by Diego Tomé Guardado on 07/10/23.
//

import UIKit
    

class MenuReportesViewController: UIViewController {
    
    @IBOutlet weak var userButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        
        userButton.setTitle("", for: .normal)

        if let userImage = UIImage(named: "icF") {
            // Ajustar imagen
            let resizedImage = resizeImage(image: userImage, targetSize: CGSize(width: 50.0, height: 40.0))

            userButton.setImage(resizedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            userButton.imageView?.contentMode = .scaleAspectFit
        }
    }

    // Funcion para cambiar medidas de imagen del boton
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        let scaleFactor = min(widthRatio, heightRatio)

        let scaledSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)

        UIGraphicsBeginImageContext(scaledSize)
        image.draw(in: CGRect(origin: .zero, size: scaledSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

}
