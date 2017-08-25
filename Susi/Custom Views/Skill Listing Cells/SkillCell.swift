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
                skillImage.kf.setImage(with: url)
                exampleQueryLabel.text = "\(skill.examples.first?.debugDescription ?? "")"
                skillName.text = skill.skillName
                skillDescription.text = skill.skillDescription
            }
            configureShadow()
        }
    }

    @IBOutlet weak var skillImage: UIImageView!
    @IBOutlet weak var exampleQueryLabel: UILabel!
    @IBOutlet weak var skillName: UILabel!
    @IBOutlet weak var skillDescription: UILabel!

    func configureShadow() {
        contentView.layer.cornerRadius = 2.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }

}
