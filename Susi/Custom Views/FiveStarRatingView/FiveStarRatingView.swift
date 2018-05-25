//
//  FiveStarRatingView.swift
//  Susi
//
//  Created by JOGENDRA on 25/05/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit
import PieCharts

class FiveStarRatingView: UIView {

    @IBOutlet weak var pieChartView: PieChart!

    fileprivate static let alpha: CGFloat = 1.0
    let colors = [
        UIColor.yellow.withAlphaComponent(alpha),
        UIColor.green.withAlphaComponent(alpha),
        UIColor.purple.withAlphaComponent(alpha),
        UIColor.cyan.withAlphaComponent(alpha),
        UIColor.darkGray.withAlphaComponent(alpha),
        UIColor.red.withAlphaComponent(alpha),
        UIColor.magenta.withAlphaComponent(alpha),
        UIColor.orange.withAlphaComponent(alpha),
        UIColor.brown.withAlphaComponent(alpha),
        UIColor.lightGray.withAlphaComponent(alpha),
        UIColor.gray.withAlphaComponent(alpha),
        ]
    fileprivate var currentColorIndex = 0

    override func awakeFromNib() {
        super.awakeFromNib()

        pieChartView.layers = [createPlainTextLayer(), createTextWithLinesLayer()]
        pieChartView.delegate = self
        pieChartView.models = createModels()
    }

    // MARK: - Models

    fileprivate func createModels() -> [PieSliceModel] {

        let models = [
            PieSliceModel(value: 1, color: colors[0]),
            PieSliceModel(value: 2, color: colors[1]),
            PieSliceModel(value: 3, color: colors[2]),
            PieSliceModel(value: 4, color: colors[3]),
            PieSliceModel(value: 5, color: colors[4])
        ]

        currentColorIndex = models.count
        return models
    }



    // MARK: - Layers

    fileprivate func createPlainTextLayer() -> PiePlainTextLayer {

        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 55
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 12.0)

        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
        }

        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
    }

    fileprivate func createTextWithLinesLayer() -> PieLineTextLayer {
        let lineTextLayer = PieLineTextLayer()
        var lineTextLayerSettings = PieLineTextLayerSettings()
        lineTextLayerSettings.lineColor = UIColor.lightGray
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        lineTextLayerSettings.label.font = UIFont.systemFont(ofSize: 14)
        lineTextLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.model.value as NSNumber).map{"\($0)"} ?? ""
        }

        lineTextLayer.settings = lineTextLayerSettings
        return lineTextLayer
    }
}

extension FiveStarRatingView: PieChartDelegate {

    func onSelected(slice: PieSlice, selected: Bool) {
        print("Selected: \(selected), slice: \(slice)")
    }

}
