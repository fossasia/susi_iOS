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

    func setupFiveStarData() {
        if let skill = skill {
            if skill.totalRatings == 0 {
                ratingsBackStackView.isHidden = true
                topAvgRatingStackView.isHidden = true
                notRatedLabel.isHidden = false
                ratingsBackViewHeightConstraint.constant = 0.0
                self.view.layoutIfNeeded()
            } else {
                barChartView.data = [skill.fiveStar, skill.fourStar, skill.threeStar, skill.twoStar, skill.oneStar]
                fiveStarLabel.text = "\(skill.fiveStar) (\(skill.fiveStar.percentage(outOf: skill.totalRatings)))%"
                fourStarLabel.text = "\(skill.fourStar) (\(skill.fourStar.percentage(outOf: skill.totalRatings)))%"
                threeStarLabel.text = "\(skill.threeStar) (\(skill.threeStar.percentage(outOf: skill.totalRatings)))%"
                twoStarLabel.text = "\(skill.twoStar) (\(skill.twoStar.percentage(outOf: skill.totalRatings)))%"
                oneStarLabel.text = "\(skill.oneStar) (\(skill.oneStar.percentage(outOf: skill.totalRatings)))%"
                averageRatingLabel.text = "\(skill.averageRating.truncate(places: 1))"
                topAvgRatingLabel.text = "\(skill.averageRating.truncate(places: 1))"
                totalRatingsLabel.text = "\(skill.totalRatings)"
            }
        }
    }

    func setupTryItTarget() {
        tryItButton.addTarget(self, action: #selector(trySkillFromExample), for: .touchUpInside)
    }

    func addRightSwipeGestureToView() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissController))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }

    @objc func dismissController() {
        navigationController?.popViewController(animated: true)
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
        contentType.widthAnchor.constraint(equalToConstant: 140).isActive = true
        contentType.heightAnchor.constraint(equalToConstant: 35).isActive = true

        if ratingsBackViewHeightConstraint.constant == 0 {
            contentType.leftAnchor.constraint(equalTo: ratingBackView.leftAnchor).isActive = true
            contentType.topAnchor.constraint(equalTo: notRatedLabel.bottomAnchor, constant: 16).isActive = true
        } else {
            contentType.leftAnchor.constraint(equalTo: ratingBackView.leftAnchor).isActive = true
            contentType.topAnchor.constraint(equalTo: ratingBackView.bottomAnchor, constant: 16).isActive = true
        }

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
        barChartView.transform = CGAffineTransform(rotationAngle: .pi/2.0)
        barChartView.barSpacing = 3
        barChartView.backgroundColor = UIColor.barBackgroundColor()
    }

}
