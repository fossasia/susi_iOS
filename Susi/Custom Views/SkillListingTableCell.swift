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
            setupCollectionView()
        }
    }

    @IBOutlet weak var groupNameLabel: UILabel!

    let skillListingCollectionView: SkillListingCollectionView = {
        let cv = SkillListingCollectionView()
        return cv
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        getSkills()
    }

    func setupCollectionView() {
        addSubview(skillListingCollectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: skillListingCollectionView)
        addConstraintsWithFormat(format: "V:|-40-[v0]|", views: skillListingCollectionView)
        skillListingCollectionView.groupName = groupName
    }

    func getSkills() {

    }

}
