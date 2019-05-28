//
//  AccountVCMethods.swift
//  Susi
//
//  Created by Syed on 28/05/19.
//  Copyright © 2019 FOSSAsia. All rights reserved.
//

import Foundation

extension AccountViewController {
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupTitle() {
        navigationItem.titleLabel.text = "Account Settings"
        navigationItem.titleLabel.textAlignment = .left
        navigationItem.titleLabel.textColor = .white
        navigationItem.leftViews = [backButton]
        navigationItem.rightViews = [settingsButton]
    }
    
    func setUpUserDetails() {
        if let user = delegate?.currentUser {
            let imageURL = URL(string: SettingsViewController.getAvatarPath(user.accessToken) )
            userAvatarImageView.kf.setImage(with: imageURL)
            userEmailLabel.text = user.emailID
            roundedCorner()
        }
    }
    
    func roundedCorner() {
        userAvatarImageView.layer.cornerRadius = 38.0
        userAvatarImageView.layer.borderWidth = 1.0
        userAvatarImageView.layer.borderColor = UIColor.iOSGray().cgColor
        userAvatarImageView.layer.masksToBounds = true
        userAvatarImageView.clipsToBounds = true
    }
    
   @objc func settingButtonClicked() {
        
    }
}
