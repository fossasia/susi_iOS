//
//  SkillDetailVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-09-01.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

extension SkillDetailViewController {

    func setupView() {
        if let skill = skill {
            skillLabel.text = skill.skillName
            if let url = URL(string: skill.imagePath) {
                skillImageView.kf.setImage(with: url)
            }
            skillAuthorLabel.text = "By: \(skill.author)"
        }
        navigationItem.backButton.tintColor = .white

        examplesCollectionView.delegate = self
        examplesCollectionView.dataSource = self
    }

    func setupTryItTarget() {
        tryItButton.addTarget(self, action: #selector(trySkillFromExample), for: .touchUpInside)
    }

    func trySkillFromExample() {
        let query = selectedExample ?? self.skill?.examples.first
        navigationController?.dismiss(animated: true, completion: {
            self.chatViewController?.inputTextField.text = query
            self.chatViewController?.handleSend()
        })
    }

    func addSkillDescription() {
        skillDescription.text = skill?.skillDescription
    }

}
