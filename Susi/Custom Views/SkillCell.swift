//
//  SkillCell.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-24.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Kingfisher

class SkillCell: BaseCell {

    var skill: Skill? {
        didSet {
            imageView.image = ControllerConstants.Images.placeholder
            if let skill = skill {
                print(skill.imagePath)
                if let url = URL(string: skill.imagePath) {
                    imageView.kf.setImage(with: url)
                }
                exampleQueryLabel.text = "\(skill.examples.first?.debugDescription ?? "")"
                skillNameLabel.text = skill.skillName
                skillDescription.text = skill.skillDescription
            }
        }
    }

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = ControllerConstants.Images.placeholder
        iv.backgroundColor = .white
        return iv
    }()

    let exampleQueryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .white
        label.numberOfLines = 2
        label.font = UIFont.italicSystemFont(ofSize: 14.0)
        return label
    }()

    let skillNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.hexStringToUIColor(hex: "#498aed")
        return label
    }()

    let skillDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 13.0)
        return label
    }()

    override func setupViews() {
        super.setupViews()

        addSubview(imageView)
        addSubview(exampleQueryLabel)
        addSubview(skillNameLabel)
        addSubview(skillDescription)

        addConstraintsWithFormat(format: "H:|-4-[v0(70)][v1]-4-|", views: imageView, exampleQueryLabel)
        addConstraintsWithFormat(format: "V:|-4-[v0(70)][v1(36)][v2]|", views: imageView, skillNameLabel, skillDescription)
        addConstraintsWithFormat(format: "V:|-4-[v0(70)]", views: exampleQueryLabel)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: skillNameLabel)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: skillDescription)
    }

}
