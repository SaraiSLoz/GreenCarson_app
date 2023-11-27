import SwiftUI
import FirebaseFirestore
import Charts

// Estructura para materiales
struct MaterialModel: Identifiable {
    let id: String
    var cantidad: Int
    let imageName: String
    var animate: Bool = false
}

// Estructura para la grafica de materiales
struct MaterialsChart: View {
    @State private var materialsList: [MaterialModel] = []

    var body: some View {
        VStack {
            if materialsList.isEmpty {
                Text("Loading data...")
            } else {
                BarChartView(data: materialsList)
            }
        }
        .onAppear {
            // Carga los datos locales primero
            fetchDataFromLocal()
            
            // Luego, actualiza la lista con datos de Firestore
            fetchDataFromFirestore()
        }
    }
    // Funcion para crear una lista local con imagenes de materiales
    func fetchDataFromLocal() {
        // Simulando datos locales, reemplaza esto con tu lógica para cargar datos locales.
        materialsList = [
            MaterialModel(id: "aceite auto", cantidad: 0, imageName: "material_aceite_auto"),
            MaterialModel(id: "aceite usado", cantidad: 0, imageName: "material_aceite_usado"),
            MaterialModel(id: "árbol", cantidad: 0, imageName: "material_arbol"),
            MaterialModel(id: "baterias", cantidad: 0, imageName: "material_baterias"),
            MaterialModel(id: "bicicletas", cantidad: 0, imageName: "material_bici"),
            MaterialModel(id: "botellas", cantidad: 0, imageName: "material_botellas"),
            MaterialModel(id: "cartón", cantidad: 0, imageName: "material_carton"),
            MaterialModel(id: "electrónicos", cantidad: 0, imageName: "material_electronicos"),
            MaterialModel(id: "escombros", cantidad: 0, imageName: "material_escombro"),
            MaterialModel(id: "industriales", cantidad: 0, imageName: "material_industriales"),
            MaterialModel(id: "juguetes", cantidad: 0, imageName: "material_juguetes"),
            MaterialModel(id: "lata chilera", cantidad: 0, imageName: "material_metal"),
            MaterialModel(id: "lata", cantidad: 0, imageName: "material_metal"),
            MaterialModel(id: "libros", cantidad: 0, imageName: "material_libros"),
            MaterialModel(id: "llantas", cantidad: 0, imageName: "material_llantas"),
            MaterialModel(id: "madera", cantidad: 0, imageName: "material_madera"),
            MaterialModel(id: "medicina", cantidad: 0, imageName: "material_medicina"),
            MaterialModel(id: "metal", cantidad: 0, imageName: "material_metal"),
            MaterialModel(id: "orgánico", cantidad: 0, imageName: "material_organico"),
            MaterialModel(id: "pallets", cantidad: 0, imageName: "material_pallets"),
            MaterialModel(id: "papel", cantidad: 0, imageName: "material_papel"),
            MaterialModel(id: "pilas", cantidad: 0, imageName: "material_pilas"),
            MaterialModel(id: "plásticos", cantidad: 0, imageName: "material_plasticos"),
            MaterialModel(id: "ropa", cantidad: 0, imageName: "material_ropa"),
            MaterialModel(id: "tapitas", cantidad: 0, imageName: "material_tapitas"),
            MaterialModel(id: "tetrapack", cantidad: 0, imageName: "material_tetrapack"),
            MaterialModel(id: "toner", cantidad: 0, imageName: "material_toner"),
            MaterialModel(id: "voluminoso", cantidad: 0, imageName: "material_voluminoso"),
            MaterialModel(id: "otro", cantidad: 0, imageName: "material_carton"),
        ]
    }
    
    // Funcion para obtener los datos con Firebase
    func fetchDataFromFirestore() {
        let db = Firestore.firestore()

        // Consulta las recolecciones con estado "Completada" y fecha del mes actual
        db.collection("recolecciones")
            .whereField("estado", isEqualTo: "Completada")
            .getDocuments { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }

                for document in documents {
                    // Accede al campo "fechaRecoleccion"
                    if let fechaRecoleccion = document["fechaRecoleccion"] as? String {
                        // Filtra por el mes actual
                        if filterByCurrentMonth(dateString: fechaRecoleccion) {
                            // Accede al campo "materiales" que es un mapa
                            if let materiales = document["materiales"] as? [String: [String: Any]] {
                                // Itera a través de los materiales y actualiza la cantidad en materialsList
                                for (_, material) in materiales {
                                    if let nombre = material["nombre"] as? String {
                                        // Llamada a la función para actualizar la cantidad
                                        let cantidad = material["cantidad"]
                                        updateMaterialCount(nombre: nombre, cantidad: cantidad as! Int)
                                    }
                                }
                            }
                        }
                    }
                }
            }
    }

    // Funcion para validar si un elemento es de la fecha actual
    func filterByCurrentMonth(dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return false
        }
        
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let recoleccionMonth = calendar.component(.month, from: date)
        
        return currentMonth == recoleccionMonth
    }
    
    // Funcion para actualizar la grafica local
    func updateMaterialCount(nombre: String, cantidad: Int) {
        // Convierte a minúsculas para comparación sin distinción entre mayúsculas y minúsculas
        let lowercaseNombre = nombre.lowercased()
        // Busca el MaterialModel correspondiente en la lista
        if let index = materialsList.firstIndex(where: { $0.id.lowercased() == lowercaseNombre }) {
            // Si se encuentra, incrementa la cantidad
            materialsList[index].cantidad += cantidad
        } else {
            // Si no se encuentra, incrementa la cantidad de "otro"
            if let otroIndex = materialsList.firstIndex(where: { $0.id == "otro" }) {
                materialsList[otroIndex].cantidad += cantidad
                print("Analizando material:", lowercaseNombre)
            }
        }
    }
}

// Esctructura de grafica de barras
struct BarChartView: View {
    let data: [MaterialModel]

    var body: some View {
        let max = data.max {
            item1, item2 in return item2.cantidad > item1.cantidad
        }?.cantidad ?? 0
        Chart(data) { materialModel in
            BarMark(
                x: .value("Cantidad", Double(materialModel.cantidad)),
                y: .value("Nombre", materialModel.id)
            )
            .annotation(position: .trailing, alignment: .center) {
                if materialModel.cantidad != 0 {
                    ZStack(alignment: .topTrailing) {
                        Image(materialModel.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)

                        Text("\(materialModel.cantidad)")
                            .font(.system(size: 12)) // Tamaño del texto
                            .foregroundColor(.black) // Color del texto
                    }
                }
            }

        }
        .chartXAxisLabel("Nombre")
        .chartYAxisLabel("Cantidad")
        .chartXScale(domain: 0...(max + 2))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MaterialsChart()
    }
}
