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

    var skillListController: SkillListingViewController?

    var groupName: String? {
        didSet {
            backgroundColor = Color.grey.lighten4
            groupNameLabel.text = groupName
         }
    }

    var skills: [Skill]? {
        didSet {
            // Sort skills in descending order of average ratings
            let sortedSkill = skills?.sorted(by: {$0.averageRating > $1.averageRating})
            skillListingCollectionView.skillListController = skillListController
            skillListingCollectionView.groupSkills = sortedSkill
        }
    }

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var skillListingCollectionView: SkillListingCollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
    }

}
