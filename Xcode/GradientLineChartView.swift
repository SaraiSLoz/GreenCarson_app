import UIKit
import DGCharts

class GradientLineChartView: UIView {
    let data: [(Int, Int)]

    init(data: [(Int, Int)]) {
        self.data = data
        super.init(frame: .zero)
        setupChart()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupChart() {
        let chartView = LineChartView()
        chartView.noDataText = "" // Hide the message when there is no data
        addSubview(chartView)

        chartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: topAnchor),
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        var entries: [ChartDataEntry] = []

        for dataPoint in data {
            let xValue = Double(dataPoint.0)
            let yValue = Double(dataPoint.1)
            let entry = ChartDataEntry(x: xValue, y: yValue)
            entries.append(entry)
        }

        let set1 = LineChartDataSet(entries: entries, label: "Cantidad de recolecciones")
        set1.mode = .cubicBezier
        set1.lineWidth = 3
        set1.setColor(.black)
        set1.fill = ColorFill(color: .red)
        set1.fillAlpha = 0.8
        set1.drawFilledEnabled = true
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.highlightColor = .systemRed
        set1.circleColors = [NSUIColor.black]
        
        let chartData = LineChartData(dataSet: set1)
        chartData.setDrawValues(true)
        chartView.data = chartData

        let xAxis = chartView.xAxis
        xAxis.labelFont = .boldSystemFont(ofSize: 14)
        xAxis.labelTextColor = .black
        xAxis.axisLineColor = .black
        xAxis.labelPosition = .bottom

        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 14)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .black
        yAxis.axisLineColor = .black
        
        // Add animation
        chartView.animate(xAxisDuration: 1.5)
    }
}
