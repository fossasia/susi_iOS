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

    weak var selectionDelegate: SkillSelectionProtocol?

    @IBOutlet weak var titleShimmerContainer: UIView!
    @IBOutlet weak var titleShimmerView: FBShimmeringView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var skillListingCollectionView: SkillListingCollectionView!
    
    var viewModel: SkillListingCellViewModel? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpDefautls()
    }

    func setUpDefautls() {
        selectionStyle = .none
        backgroundColor = Color.grey.lighten4
    }

    func updateView() {
        shouldShimmer(showShimmer: viewModel?.isLoading ?? false)
        groupNameLabel.text = viewModel?.groupName
        let sortedSkill = viewModel?.skill?.sorted(by: {$0.averageRating > $1.averageRating})
        skillListingCollectionView.selectionDelegate = viewModel?.skillListController
        skillListingCollectionView.isLoading = viewModel?.isLoading ?? false
        skillListingCollectionView.groupSkills = sortedSkill
    }
    
    func shouldShimmer(showShimmer: Bool) {
        titleShimmerView.contentView = titleShimmerContainer
        titleShimmerView.isShimmering = showShimmer
        groupNameLabel.isHidden = showShimmer
        titleShimmerContainer.isHidden = !showShimmer
        titleShimmerView.isHidden = !showShimmer
    }
}
