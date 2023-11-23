import SwiftUI
import FirebaseFirestore
import Charts

struct MaterialModel: Identifiable {
    let id: String
    let cantidad: Int
    let imageName: String
}

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
            fetchDataFromLocal()
        }
    }

    func fetchDataFromLocal() {
        // Simulando datos locales de materiales
        materialsList = [
            MaterialModel(id: "aceite de auto", cantidad: 0, imageName: "material_aceite_auto"),
            MaterialModel(id: "aceite usado", cantidad: 0, imageName: "material_aceite_usado"),
            MaterialModel(id: "árbol", cantidad: 0, imageName: "material_arbol"),
            MaterialModel(id: "baterias", cantidad: 0, imageName: "material_baterias"),
            MaterialModel(id: "bici", cantidad: 0, imageName: "material_bici"),
            MaterialModel(id: "botellas", cantidad: 0, imageName: "material_botellas"),
            MaterialModel(id: "carton", cantidad: 0, imageName: "material_carton"),
            MaterialModel(id: "electronicos", cantidad: 0, imageName: "material_electronicos"),
            MaterialModel(id: "escombro", cantidad: 0, imageName: "material_escombro"),
            MaterialModel(id: "industriales", cantidad: 0, imageName: "material_industriales"),
            MaterialModel(id: "juguetes", cantidad: 0, imageName: "material_juguetes"),
            MaterialModel(id: "libros", cantidad: 0, imageName: "material_libros"),
            MaterialModel(id: "llantas", cantidad: 0, imageName: "material_llantas"),
            MaterialModel(id: "madera", cantidad: 0, imageName: "material_madera"),
            MaterialModel(id: "medicina", cantidad: 0, imageName: "material_medicina"),
            MaterialModel(id: "metal", cantidad: 0, imageName: "material_metal"),
            MaterialModel(id: "organico", cantidad: 0, imageName: "material_organico"),
            MaterialModel(id: "pallets", cantidad: 0, imageName: "material_pallets"),
            MaterialModel(id: "papel", cantidad: 0, imageName: "material_papel"),
            MaterialModel(id: "pilas", cantidad: 0, imageName: "material_pilas"),
            MaterialModel(id: "plasticos", cantidad: 0, imageName: "material_plasticos"),
            MaterialModel(id: "ropa", cantidad: 0, imageName: "material_ropa"),
            MaterialModel(id: "tapitas", cantidad: 0, imageName: "material_tapitas"),
            MaterialModel(id: "tetrapack", cantidad: 0, imageName: "material_tetrapack"),
            MaterialModel(id: "toner", cantidad: 5, imageName: "material_toner"),
            MaterialModel(id: "voluminoso", cantidad: 7, imageName: "material_voluminoso"),
            MaterialModel(id: "otro", cantidad: 0, imageName: "material_carton"),
        ]
    }
}

struct BarChartView: View {
    let data: [MaterialModel]

    // Se crea vista de grafica de barras
    var body: some View {
        Chart(data) { materialModel in
            BarMark(
                x: .value("Cantidad", Double(materialModel.cantidad)),
                y: .value("Nombre", materialModel.id)
            )
            .annotation(position: .trailing, alignment: .center) {
                if materialModel.cantidad != 0 {
                    VStack {
                        Text("\(materialModel.cantidad)")
                        Image(materialModel.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                }
            }
        }
        .chartXAxisLabel("Nombre")
        .chartYAxisLabel("Cantidad")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MaterialsChart()
    }
}
