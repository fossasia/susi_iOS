//
//  SkillDetailViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-30.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Kingfisher
import Material
import PieCharts

class SkillDetailViewController: GeneralViewController {

//    let rating: UILabel = {
//        let label = UILabel()
//        label.text = "Rating"
//        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    let positiveRating: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    let negativeRating: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()

    let contentType: UILabel = {
        let label = UILabel()
        label.text = "Content Type:"
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let content: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    var skill: Skill?
    var chatViewController: ChatViewController?
    var selectedExample: String?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var skillImageView: UIImageView!
    @IBOutlet weak var skillAuthorLabel: UILabel!
    @IBOutlet weak var tryItButton: FlatButton!
    @IBOutlet weak var skillDescription: UILabel!
    @IBOutlet weak var examplesCollectionView: UICollectionView!
    @IBOutlet weak var exampleHeading: UILabel!

    @IBOutlet weak var pieChartView: PieChart!

    fileprivate static let alpha: CGFloat = 1.0
    let colors = [
        UIColor.iOSGreen(),
        UIColor.iOSTealBlue(),
        UIColor.iOSYellow(),
        UIColor.iOSOrange(),
        UIColor.iOSRed()
    ]
    fileprivate var currentColorIndex = 0

    // MARK: - Models

    fileprivate func createModels() -> [PieSliceModel] {

        let models = [
            PieSliceModel(value: 10, color: colors[0]),
            PieSliceModel(value: 7, color: colors[1]),
            PieSliceModel(value: 3, color: colors[2]),
            PieSliceModel(value: 8, color: colors[3]),
            PieSliceModel(value: 5, color: colors[4])
        ]

        currentColorIndex = models.count
        return models
    }



    // MARK: - Layers

    fileprivate func createPlainTextLayer() -> PiePlainTextLayer {

        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 35.0
        textLayerSettings.hideOnOverflow = false
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 10.0)

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
        lineTextLayerSettings.segment1Length = 10.0
        lineTextLayerSettings.segment2Length = 5.0
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        lineTextLayerSettings.label.font = UIFont.systemFont(ofSize: 12)
        lineTextLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.model.value as NSNumber).map{"\($0)"} ?? ""
        }

        lineTextLayer.settings = lineTextLayerSettings
        return lineTextLayer
    }

    @IBOutlet weak var ratingView: FloatRatingView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        roundedCorner()
        setupTryItTarget()
        addSkillDescription()

//        view.addSubview(rating)
//        rating.leftAnchor.constraint(equalTo: exampleHeading.leftAnchor).isActive = true
//        rating.topAnchor.constraint(equalTo: examplesCollectionView.bottomAnchor, constant: 35).isActive = true
//        rating.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        rating.heightAnchor.constraint(equalToConstant: 22).isActive = true

        //addRating()
        addContentType()
        pieChartView.layers = [createPlainTextLayer(), createTextWithLinesLayer()]
        pieChartView.delegate = self
        pieChartView.models = createModels()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 200)
    }
    override func localizeStrings() {
        tryItButton.setTitle(ControllerConstants.tryIt.localized(), for: .normal)
    }

    func roundedCorner() {
        skillImageView.layer.cornerRadius = 0.5 * skillImageView.frame.width
        skillImageView.clipsToBounds = true

        tryItButton.layer.cornerRadius = 18.0
        tryItButton.layer.borderWidth = 2.0
        tryItButton.borderColor = UIColor.iOSBlue()
    }

}
