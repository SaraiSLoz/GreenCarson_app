//
//  ResiduosViewController.swift
//  Reportes Vistas
//
//  Created by Diego Tomé Guardado on 08/11/23.
//

import UIKit

struct Item {
    var number: Int
    var text: String
    var iconName: String
}

class ResiduosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var tableView: UITableView!
    
    var items: [Item] = [] // Aquí deberías cargar los datos desde tu base de datos

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configurar la tabla
        tableView.dataSource = self
        tableView.delegate = self

        // Aquí deberías cargar los datos desde tu base de datos
        // Puedes hacerlo de forma asíncrona y luego recargar la tabla
        fetchData()
    }

    // Función para cargar datos desde la base de datos (simulada)
    func fetchData() {
        // Simulación de carga de datos desde la base de datos
        items = [
            Item(number: 1, text: "Primer elemento", iconName: "ic1"),
            Item(number: 2, text: "Segundo elemento", iconName: "ic1x"),
            Item(number: 3, text: "Tercer elemento", iconName: "ic1")
        ]

        // Recargar la tabla después de obtener datos
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)

        // Configurar la celda con los datos del elemento
        let item = items[indexPath.row]
        cell.textLabel?.text = "\(item.number) - \(item.text)"
        cell.imageView?.image = UIImage(systemName: item.iconName)

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Manejar la selección de una celda si es necesario
    }
}
