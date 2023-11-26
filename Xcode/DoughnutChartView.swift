import UIKit
import DGCharts

class DoughnutChartView: UIView {
    let data: [String: Int]

    init(data: [String: Int]) {
        self.data = data
        super.init(frame: .zero)
        setupChart()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupChart() {
        let chartView = PieChartView()
        chartView.noDataText = "" // Ocultar el mensaje cuando no hay datos
        addSubview(chartView)

        chartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: topAnchor),
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        var entries: [PieChartDataEntry] = []
        let total = data.values.reduce(0, +)

        for (key, value) in data {
            let percentage = (Double(value) / Double(total)) * 100.0
            entries.append(PieChartDataEntry(value: percentage, label: "\(key): \(String(format: "%.2f", percentage))%"))
        }

        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = [NSUIColor.red, NSUIColor.green]
        dataSet.valueTextColor = NSUIColor.black
        dataSet.valueFont = UIFont.systemFont(ofSize: 12.0)

        // Deshabilitar la impresión de descripción
        chartView.data = PieChartData(dataSet: dataSet)

        chartView.drawHoleEnabled = true
        chartView.holeColor = NSUIColor.clear
        chartView.holeRadiusPercent = 0.7
        chartView.drawEntryLabelsEnabled = false // No mostrar etiquetas dentro de la gráfica

        // Add animation
        chartView.animate(xAxisDuration: 2.0, easingOption: .easeOutQuad)
    }

}
