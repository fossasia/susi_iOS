//
//  SkillListingTableCell.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-24.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material

class SkillListingTableCell: UITableViewCell {

    var groupName: String? {
        didSet {
            backgroundColor = Color.grey.lighten3
            groupNameLabel.text = groupName
         }
    }

    var skills: [Skill]? {
        didSet {
            skillListingCollectionView.groupSkills = skills
        }
    }

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var skillListingCollectionView: SkillListingCollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
    }

}
