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
    var submitRatingParams: [String: AnyObject] = [:]
    var getRatingParam: [String: AnyObject] = [:]
    var postFeedbackParam: [String: AnyObject] = [:]

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var skillImageView: UIImageView!
    @IBOutlet weak var skillAuthorLabel: UILabel!
    @IBOutlet weak var tryItButton: FlatButton!
    @IBOutlet weak var skillDescription: UILabel!
    @IBOutlet weak var examplesCollectionView: UICollectionView!
    @IBOutlet weak var exampleHeading: UILabel!
    @IBOutlet weak var ratingView: RatingView! {
        didSet {
            ratingView.delegate = self
        }
    }
    @IBOutlet weak var averageRatingLabel: UILabel!
    @IBOutlet weak var totalRatingsLabel: UILabel!
    @IBOutlet weak var topAvgRatingLabel: UILabel!
    @IBOutlet weak var barChartView: TEABarChart!
    @IBOutlet weak var ratingBackView: UIView!
    @IBOutlet weak var fiveStarLabel: UILabel!
    @IBOutlet weak var fourStarLabel: UILabel!
    @IBOutlet weak var threeStarLabel: UILabel!
    @IBOutlet weak var twoStarLabel: UILabel!
    @IBOutlet weak var oneStarLabel: UILabel!
    @IBOutlet weak var ratingsBackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topAvgRatingStackView: UIStackView!
    @IBOutlet weak var ratingsBackStackView: UIStackView!
    @IBOutlet weak var notRatedLabel: UILabel!
    @IBOutlet weak var skillFeedbackTextField: TextField! {
        didSet {
            skillFeedbackTextField.delegate = self
        }
    }
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var feedbackLabelTopConstraintToRatings: NSLayoutConstraint!
    @IBOutlet weak var feedbackLabelToContraintToNoRated: NSLayoutConstraint!

    let barChartColors = [
        UIColor.fiveStarRating(),
        UIColor.fourStarRating(),
        UIColor.threeStarRating(),
        UIColor.twoStarRating(),
        UIColor.oneStarRating()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()
        setupView()
        setupPostButton()
        roundedCorner()
        setupTryItTarget()
        addSkillDescription()
        getRatingByUser()
        setupFiveStarData()
        setupBarChart()
        addContentType()
        setupFeedbackTextField()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // ScrollView content size
        let labelHeight = skillDescription.heightForLabel(text: skillDescription.text!, font: UIFont.systemFont(ofSize: 16.0), width: self.view.frame.width - 64)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 264.0 + labelHeight)
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
        ratingBackView.layer.cornerRadius = 8.0
        postButton.layer.cornerRadius = 4.0
    }

}
