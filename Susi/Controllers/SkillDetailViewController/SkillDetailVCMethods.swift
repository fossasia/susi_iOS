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
            skillAuthorLabel.text = "Author: \(skill.author)"
        }
        navigationItem.backButton.tintColor = .white

        examplesCollectionView.delegate = self
        examplesCollectionView.dataSource = self
    }

    func setupTryItTarget() {
        tryItButton.addTarget(self, action: #selector(trySkillFromExample), for: .touchUpInside)
    }

    @objc func trySkillFromExample() {
        let query = selectedExample ?? self.skill?.examples.first
        navigationController?.dismiss(animated: true, completion: {
            self.chatViewController?.inputTextField.text = query
            self.chatViewController?.handleSend()
        })
    }

    func addSkillDescription() {
        skillDescription.text = skill?.skillDescription
    }

    func addContentType() {
        view.addSubview(contentType)
        contentType.leftAnchor.constraint(equalTo: ratingBackView.leftAnchor).isActive = true
        contentType.widthAnchor.constraint(equalToConstant: 140).isActive = true
        contentType.heightAnchor.constraint(equalToConstant: 35).isActive = true
        contentType.topAnchor.constraint(equalTo: ratingBackView.bottomAnchor, constant: 16).isActive = true

        view.addSubview(content)
        content.leftAnchor.constraint(equalTo: contentType.rightAnchor, constant: -6).isActive = true
        content.topAnchor.constraint(equalTo: contentType.topAnchor, constant: 8).isActive = true
        content.widthAnchor.constraint(equalToConstant: 140).isActive = true
        content.heightAnchor.constraint(equalToConstant: 22).isActive = true

        guard let contents = skill?.dynamic_content else { return }
        if contents {
            content.text = "Dynamic"
        } else {
            content.text = "Non-Dynamic"
        }

    }

    // Setup Bar Chart
    func setupBarChart() {
        barChartView.barColors = barChartColors
        barChartView.data = [5, 1, 1, 1, 2]
        barChartView.transform = CGAffineTransform(rotationAngle: .pi/2.0)
        barChartView.barSpacing = 3
        barChartView.backgroundColor = UIColor.barBackgroundColor()
    }

}
