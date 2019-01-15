//
//  AboutVCMethods.swift
//  Susi
//
//  Created by Syed on 25/12/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import Foundation

extension AboutViewController {
    
    func susiDescription() {
        let originalText = ControllerConstants.AboutUs.susiDescription
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let linkRange = attributedOriginalText.mutableString.range(of: "SUSI.AI")
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .link: URL(string: ControllerConstants.CommonURL.susiURL)!
        ]
        attributedOriginalText.addAttributes(attributes, range: linkRange)
        susiDescriptionTextView.attributedText = attributedOriginalText
        susiDescriptionTextView.textColor = .darkGray
        susiDescriptionTextView.font = .systemFont(ofSize: 17)
        susiDescriptionTextView.isScrollEnabled = false
        susiDescriptionTextView.isEditable = false
        susiDescriptionTextView.translatesAutoresizingMaskIntoConstraints = true
        susiDescriptionTextView.sizeToFit()
    }
    
    func contributorsDescription() {
        let originalText = ControllerConstants.AboutUs.contributersDescription
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let linkRange = attributedOriginalText.mutableString.range(of: "Contributors")
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .link: URL(string: ControllerConstants.CommonURL.contributorsURL)!
        ]
        attributedOriginalText.addAttributes(attributes, range: linkRange)
        contributorsTextView.attributedText = attributedOriginalText
        contributorsTextView.textColor = .darkGray
        contributorsTextView.font = .systemFont(ofSize: 17)
        contributorsTextView.isScrollEnabled = false
        contributorsTextView.isEditable = false
    }
    
    func susiSkillDescription() {
        let originalText = ControllerConstants.AboutUs.susiSkillDescription
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let linkRange = attributedOriginalText.mutableString.range(of: "skills.susi.ai")
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .link: URL(string: ControllerConstants.CommonURL.susiSkillURL)!
        ]
        attributedOriginalText.addAttributes(attributes, range: linkRange)
        susiSkillTextView.attributedText = attributedOriginalText
        susiSkillTextView.textColor = .darkGray
        susiSkillTextView.font = .systemFont(ofSize: 17)
        susiSkillTextView.isScrollEnabled = false
        susiSkillTextView.isEditable = false
    }
    
    func reportIssueDescription() {
        let originalText = ControllerConstants.AboutUs.reportIssueDescription
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let linkRange = attributedOriginalText.mutableString.range(of: "Github Repository Issue Tracker")
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .link: URL(string: ControllerConstants.CommonURL.reportIssueURL)!
        ]
        attributedOriginalText.addAttributes(attributes, range: linkRange)
        reportIssueTextView.attributedText = attributedOriginalText
        reportIssueTextView.textColor = .darkGray
        reportIssueTextView.font = .systemFont(ofSize: 17)
        reportIssueTextView.isScrollEnabled = false
        reportIssueTextView.isEditable = false
    }
    
    func licenseDescription() {
        let originalText = ControllerConstants.AboutUs.licenseDescription
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let linkRange = attributedOriginalText.mutableString.range(of: "LICENSE.md")
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .link: URL(string: ControllerConstants.CommonURL.licenseURL)!
        ]
        attributedOriginalText.addAttributes(attributes, range: linkRange)
        licenseDescriptionTextView.attributedText = attributedOriginalText
        licenseDescriptionTextView.textColor = .darkGray
        licenseDescriptionTextView.font = .systemFont(ofSize: 17)
        licenseDescriptionTextView.isScrollEnabled = false
        licenseDescriptionTextView.isEditable = false
    }
    
}
