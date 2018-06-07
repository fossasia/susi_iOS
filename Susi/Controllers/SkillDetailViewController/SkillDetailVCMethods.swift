//
//  SkillDetailVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-09-01.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import PieCharts

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
        contentType.leftAnchor.constraint(equalTo: positiveRatingLabel.leftAnchor).isActive = true
        contentType.widthAnchor.constraint(equalToConstant: 140).isActive = true
        contentType.heightAnchor.constraint(equalToConstant: 35).isActive = true
        contentType.topAnchor.constraint(equalTo: positiveRatingLabel.bottomAnchor, constant: 16).isActive = true

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

}

extension SkillDetailViewController: PieChartDelegate {

    func onSelected(slice: PieSlice, selected: Bool) {
        print("Selected: \(selected), slice: \(slice)")
    }

    // MARK: - Layers

    func createPlainTextLayer() -> PiePlainTextLayer {

        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 45.0
        textLayerSettings.hideOnOverflow = false
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 12.0)

        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map { "\($0)%"} ?? ""
        }

        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
    }

    func createTextWithLinesLayer() -> PieLineTextLayer {
        let lineTextLayer = PieLineTextLayer()
        var lineTextLayerSettings = PieLineTextLayerSettings()
        lineTextLayerSettings.lineColor = UIColor.lightGray
        lineTextLayerSettings.segment1Length = 10.0
        lineTextLayerSettings.segment2Length = 10.0
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        lineTextLayerSettings.label.font = UIFont.systemFont(ofSize: 14)
        lineTextLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.model.value as NSNumber).map { "\($0)"} ?? ""
        }

        lineTextLayer.settings = lineTextLayerSettings
        return lineTextLayer
    }

    // MARK: - Models

    func createModels() -> [PieSliceModel] {

        let models = [
            PieSliceModel(value: 10, color: colors[0]),
            PieSliceModel(value: 8, color: colors[1]),
            PieSliceModel(value: 6, color: colors[2]),
            PieSliceModel(value: 8, color: colors[3]),
            PieSliceModel(value: 5, color: colors[4])
        ]

        currentColorIndex = models.count
        return models
    }

}
