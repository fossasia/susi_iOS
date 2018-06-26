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

    func roundedCorner() {
        iconTitleView.layer.cornerRadius = 16.0
        skillImage.layer.cornerRadius = 0.5 * skillImage.frame.width
        skillImage.clipsToBounds = true
    }

}
