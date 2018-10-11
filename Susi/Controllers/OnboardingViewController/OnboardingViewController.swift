//
//  OnboardingViewController.swift
//  Susi
//
//  Created by JOGENDRA on 16/05/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingViewController: UIViewController {

    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var bottomLoginSkipButton: UIButton!

    let items = [
        OnboardingItemInfo(informationImage: Asset.login.image,
                           title: ControllerConstants.Onboarding.login,
                           description: ControllerConstants.Onboarding.loginDescription,
                           pageIcon: Asset.pageIcon.image,
                           color: UIColor.skillOnboardingColor(),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),

        OnboardingItemInfo(informationImage: Asset.chat.image,
                           title: ControllerConstants.Onboarding.chatInterface,
                           description: ControllerConstants.Onboarding.chatInterfaceDescription,
                           pageIcon: Asset.pageIcon.image,
                           color: UIColor.chatOnboardingColor(),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),

        OnboardingItemInfo(informationImage: Asset.skill.image,
                           title: ControllerConstants.Onboarding.skillListing,
                           description: ControllerConstants.Onboarding.skillListingDescription,
                           pageIcon: Asset.pageIcon.image,
                           color: UIColor.loginOnboardingColor(),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),

        OnboardingItemInfo(informationImage: Asset.skillSettings.image,
                           title: ControllerConstants.Onboarding.chatSettings,
                           description: ControllerConstants.Onboarding.chatSettingsDescription,
                           pageIcon: Asset.pageIcon.image,
                           color: UIColor.iOSBlue(),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont)

        ]

    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.statusBarStyle = .lightContent
        view.accessibilityIdentifier = "onboardingView"

        setupPaperOnboardingView()
        skipButton.isHidden = false
        bottomLoginSkipButton.isHidden = true
        view.bringSubviewToFront(skipButton)
        view.bringSubviewToFront(bottomLoginSkipButton)
    }

    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding()
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)

        // Add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }

    @IBAction func didSkipOnboardings(_ sender: Any) {
    }

}

extension OnboardingViewController: PaperOnboardingDelegate, PaperOnboardingDataSource {

    func onboardingItemsCount() -> Int {
        return items.count
    }

    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }

    func onboardingWillTransitonToIndex(_ index: Int) {
        skipButton.isHidden = index == 3 ? true : false
        bottomLoginSkipButton.isHidden = index == 3 ? false : true
    }

}

// MARK: Constants
extension OnboardingViewController {
    private static let titleFont = UIFont.systemFont(ofSize: 36.0)
    private static let descriptionFont = UIFont.systemFont(ofSize: 17.0)
}
