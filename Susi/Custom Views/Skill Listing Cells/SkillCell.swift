//
//  SkillCell.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-24.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Kingfisher
import Material

class SkillCell: CollectionViewCell {
    var isLoading: Bool = false {
        didSet {
            showShimmer( shouldShow: isLoading)
        }
    }
    var skill: Skill? {
        didSet {
            skillImage.image = ControllerConstants.Images.placeholder
            if let skill = skill {
                let url = URL(string: skill.imagePath)
                skillImage.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, _, _) in
                    if image == nil || error != nil {
                        self.skillImage.image = ControllerConstants.Images.placeholder
                    }
                })
                exampleQueryLabel.text = "\(skill.examples.first?.debugDescription ?? "example query")"
                skillName.text = skill.skillName
                skillDescription.text = skill.skillDescription
                ratingsCard.rating = skill.averageRating
                totalRatingsLabel.text = "\(skill.totalRatings)"
            }
            configureShadow()
            roundedCorner()
        }
    }

    @IBOutlet weak var iconTitleView: UIView!
    @IBOutlet weak var skillImage: UIImageView!
    @IBOutlet weak var exampleQueryLabel: UILabel!
    @IBOutlet weak var skillName: UILabel!
    @IBOutlet weak var skillDescription: UILabel!
    @IBOutlet weak var ratingsCard: RatingView!
    @IBOutlet weak var totalRatingsLabel: UILabel!
    
    @IBOutlet weak var topShimmer: FBShimmeringView!
    @IBOutlet weak var topShimmerContainer: UIView!

    @IBOutlet weak var middleShimmerView: FBShimmeringView!
    @IBOutlet weak var middleShimmerContainer: UIView!
   
    @IBOutlet weak var bottomShimmerView: FBShimmeringView!
    @IBOutlet weak var bottomShimmerContainer: UIView!
    //    @IBOutlet weak var iconTitleSV: FBShimmeringView!
    @IBOutlet weak var ratingShimmerContainer: UIView!
    @IBOutlet weak var ratingShimmerView: FBShimmeringView!
    //
//    @IBOutlet weak var exampleQueryLabelSV: FBShimmeringView!
//
//    @IBOutlet weak var skillDescriptionSV: FBShimmeringView!
//    @IBOutlet weak var ratingsCardSV: FBShimmeringView!
//    @IBOutlet weak var totalRatingsSV: FBShimmeringView!

    func configureShadow() {
        contentView.layer.cornerRadius = 16.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.black.withAlphaComponent(0.16).cgColor
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    func showShimmer( shouldShow: Bool ) {
        iconTitleView.isHidden = shouldShow
        skillImage.isHidden = shouldShow
        exampleQueryLabel.isHidden = shouldShow
        skillName.isHidden = shouldShow
        skillDescription.isHidden = shouldShow
        ratingsCard.isHidden = shouldShow
        totalRatingsLabel.isHidden = shouldShow
        topShimmer.isHidden = !shouldShow
        bottomShimmerView.isHidden = !shouldShow
        bottomShimmerView.isHidden = !shouldShow
        ratingShimmerContainer.isHidden = !shouldShow
        bottomShimmerView.isHidden = !shouldShow
        middleShimmerContainer.isHidden = !shouldShow
        bottomShimmerContainer.isHidden = !shouldShow
        ratingShimmerView.isHidden = !shouldShow
        topShimmerContainer.isHidden = !shouldShow
        topShimmer.contentView = topShimmerContainer
        bottomShimmerView.contentView = bottomShimmerContainer
        middleShimmerView.contentView = middleShimmerContainer
        ratingShimmerView.contentView = ratingShimmerContainer
        bottomShimmerView.isShimmering = shouldShow
        middleShimmerView.isShimmering = shouldShow
        topShimmer.isShimmering = shouldShow
        ratingShimmerView.isShimmering = shouldShow
    }
    
    func roundedCorner() {
        iconTitleView.layer.cornerRadius = 16.0
        skillImage.layer.cornerRadius = 0.5 * skillImage.frame.width
        skillImage.clipsToBounds = true
    }

}
