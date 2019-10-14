//
//  AccountVCMethods.swift
//  Susi
//
//  Created by Syed on 28/05/19.
//  Copyright © 2019 FOSSAsia. All rights reserved.
//

import Foundation

extension AccountViewController: UITextFieldDelegate {
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupTitle() {
        navigationItem.titleLabel.text = ControllerConstants.SettingParams.title
        navigationItem.titleLabel.textAlignment = .left
        navigationItem.titleLabel.textColor = .white
        navigationItem.leftViews = [backButton]
        navigationItem.rightViews = [settingsButton]
        deleteAccountButton.tintColor = .red
    }
    
    func setUpUserDetails() {
        if let user = delegate?.currentUser {
            let imageURL = URL(string: SettingsViewController.getAvatarPath(user.accessToken) )
            userAvatarImageView.kf.setImage(with: imageURL)
            if UserDefaults.standard.object(forKey: ControllerConstants.SettingParams.userName) == nil {
                userEmailLabel.text = user.emailID
            } else {
                userEmailLabel.text = UserDefaults.standard.object(forKey: ControllerConstants.SettingParams.userName) as? String
            }
            roundedCorner()
            outerViewShadow()
        }
    }
    
    func roundedCorner() {
        userAvatarImageView.layer.cornerRadius = 38.0
        userAvatarImageView.layer.borderWidth = 1.0
        userAvatarImageView.layer.borderColor = UIColor.white.cgColor
        userAvatarImageView.layer.masksToBounds = true
        userAvatarImageView.clipsToBounds = true
    }
    
    // Outer View
    
    func outerViewShadow() {
        outerView.layer.cornerRadius = 38.0
        outerView.layer.shadowColor = UIColor.gray.cgColor
        outerView.layer.shadowOpacity = 1
        outerView.layer.shadowRadius = 10.0
        outerView.layer.shadowOffset = CGSize.zero
    }
    
    // Setting Action 
    
   @objc func settingButtonClicked() {
    if  let user = delegate?.currentUser {
        let param = [
            ControllerConstants.SettingParams.userName: userNameTextField.text as AnyObject,
            ControllerConstants.SettingParams.phoneNumber: phoneNumberTextField.text as AnyObject,
            ControllerConstants.SettingParams.prefLanguage: prefLanguageTextField.text as AnyObject,
            ControllerConstants.SettingParams.count: 3 as AnyObject,
            ControllerConstants.SettingParams.accessToken: user.accessToken as AnyObject
        ]
        Client.sharedInstance.changeUserSettings(param) { (_, message) in
            DispatchQueue.main.async {
                UserDefaults.standard.set(self.userNameTextField.text, forKey: ControllerConstants.SettingParams.userName)
                self.view.makeToast(message)
            }
        }
    }
    }
    
    // Key Return on Hit
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userNameTextField:
            _ =  phoneNumberTextField.becomeFirstResponder()
        case phoneNumberTextField:
            dismissKeyboard()        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    // Dismiss Keyboard
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Add Delegates
    
    func addDelegates() {
        userNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        picker.dataSource = self
        picker.delegate = self
        prefLanguageTextField.inputView = picker
    }
    
    // Handle Delete Account Request.
    
    func handleDeleteAccountRequest() {
        deleteAccountButton.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
    }
    
    @objc func deleteAccount() {
        
    }
    
    // Handle Upload Avatar
    
    func handleAvatarUpload() {
        uploadAvatarButton.addTarget(self, action: #selector(uploadAvatar), for: .touchUpInside)
    }
    
    @objc func uploadAvatar() {
    
    }
    
}
