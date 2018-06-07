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
        label.textColor = UIColor.iOSGray()
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
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var averageRatingLabel: UILabel!
    @IBOutlet weak var totalRatingsLabel: UILabel!
    @IBOutlet weak var positiveRatingLabel: UILabel!
    @IBOutlet weak var negativeRatingLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var topAvgRatingLabel: UILabel!

    static let alpha: CGFloat = 1.0
    let colors = [
        UIColor.iOSGreen(),
        UIColor.iOSTealBlue(),
        UIColor.iOSYellow(),
        UIColor.iOSOrange(),
        UIColor.iOSRed()
    ]

    var currentColorIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        addRightSwipeGestureToView()
        roundedCorner()
        setupSubmitButton()
        setupTryItTarget()
        addSkillDescription()
        addContentType()
        pieChartView.layers = [createPlainTextLayer(), createTextWithLinesLayer()]
        pieChartView.delegate = self
        pieChartView.models = createModels()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // ScrollView content size
        let labelHeight = skillDescription.heightForLabel(text: skillDescription.text!, font: UIFont.systemFont(ofSize: 16.0), width: self.view.frame.width - 64)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 258 + labelHeight)
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

    func setupSubmitButton() {
        submitButton.layer.borderColor = UIColor.iOSGray().cgColor
        submitButton.layer.borderWidth = 2.0
        submitButton.layer.cornerRadius = 15.0
    }
}
