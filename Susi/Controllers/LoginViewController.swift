//
//  LoginViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material
import Toast_Swift

class LoginViewController: UIViewController {
    
    // Setup Susi Logo
    let susiLogo: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "susi")
        return iv
    }()
    
    // Setup Email Text Field
    lazy var emailField: ErrorTextField = {
        let textField = ErrorTextField()
        textField.keyboardType = .emailAddress
        textField.placeholder = "Email Address"
        textField.detail = "Error, incorrect email"
        textField.detailColor = .red
        textField.isClearIconButtonEnabled = true
        textField.placeholderNormalColor = .white
        textField.placeholderActiveColor = .white
        textField.dividerNormalColor = .white
        textField.dividerActiveColor = .white
        textField.textColor = .white
        textField.clearIconButton?.tintColor = .white
        textField.isErrorRevealed = false
        textField.delegate = self
        return textField
    }()
    
    // Setup Password Field
    let passwordField: TextField = {
        let textField = TextField()
        textField.placeholder = "Password"
        textField.detail = "At least 8 characters"
        textField.placeholderNormalColor = .white
        textField.placeholderActiveColor = .white
        textField.dividerNormalColor = .white
        textField.dividerActiveColor = .white
        textField.detailColor = .white
        textField.textColor = .white
        textField.clearIconButton?.tintColor = .white
        textField.clearButtonMode = .whileEditing
        textField.isVisibilityIconButtonEnabled = true
        textField.visibilityIconButton?.tintColor = Color.white.withAlphaComponent(textField.isSecureTextEntry ? 0.38 : 0.54)
        return textField
    }()
    
    // Setup Login Button
    lazy var loginButton: RaisedButton = {
        let button = RaisedButton()
        button.setTitle("LOGIN", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(UIColor.defaultColor(), for: .normal)
        button.addTarget(self, action: #selector(performLogin), for: .touchUpInside)
        return button
    }()
    
    // Setup Forgot Button
    let forgotButton: FlatButton = {
        let button = FlatButton()
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // Setup Sign Up Button
    lazy var signUpButton: FlatButton = {
        let button = FlatButton()
        button.setTitle("Sign up for SUSI", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(showSignUpView), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // Setup View
    func setupView() {
        self.view.backgroundColor = UIColor.defaultColor()
        
        prepareLogo()
        prepareEmailField()
        preparePasswordField()
        prepareLoginButton()
        prepareForgotButton()
        prepareSignUpButton()
    }
    
    // Add Subview Logo
    private func prepareLogo() {
        self.view.addSubview(susiLogo)
        self.view.layout(susiLogo).top(50).centerHorizontally()
    }
    
    // Add Subview Email Field
    private func prepareEmailField() {
        self.view.addSubview(emailField)
        self.view.layout(emailField).center(offsetY: -passwordField.height - 140).left(20).right(20)
    }
    
    // Add Subview Password Field
    private func preparePasswordField() {
        self.view.addSubview(passwordField)
        self.view.layout(passwordField).center(offsetY: -60).left(20).right(20)
    }
    
    // Add Subview Login Button
    private func prepareLoginButton() {
        self.view.addSubview(loginButton)
        self.view.layout(loginButton).height(44).center(offsetY: passwordField.height).left(20).right(20)
    }
    
    // Add Subview Forgot Button
    private func prepareForgotButton() {
        self.view.addSubview(forgotButton)
        self.view.layout(forgotButton).height(44).center(offsetY: loginButton.frame.maxY + 60).left(20).right(20)
    }
    
    // Add Subview Sign Up Button
    private func prepareSignUpButton() {
        self.view.addSubview(signUpButton)
        self.view.layout(signUpButton).height(44).center(offsetY: forgotButton.height + 120).left(20).right(20)
    }
    
    // Login User
    func performLogin() {
        
        toggleEditing()
        
        let params = [
            Client.UserKeys.Login: emailField.text!.lowercased(),
            Client.UserKeys.Password: passwordField.text!,
            "type": "access-token"
        ] as [String : Any]
        
        Client.sharedInstance.loginUser(params as [String : AnyObject]) { (success, message) in
            DispatchQueue.main.async {
                self.toggleEditing()
                if success {
                    let vc = MainViewController(collectionViewLayout: UICollectionViewFlowLayout())
                    let nvc = UINavigationController(rootViewController: vc)
                    self.present(nvc, animated: true, completion: {
                        nvc.view.makeToast(message)
                    })
                }
                self.view.makeToast(message)
            }
        }
    }
    
    func toggleEditing() {
        emailField.isEnabled = !emailField.isEnabled
        passwordField.isEnabled = !passwordField.isEnabled
        loginButton.isEnabled = !loginButton.isEnabled
    }
    
    func showSignUpView() {
        let vc = SignUpViewController()
        self.present(vc, animated: true, completion: nil)
    }

}

extension LoginViewController: TextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let emailID = emailField.text, !emailID.isValidEmail() {
            (textField as? ErrorTextField)?.isErrorRevealed = true
        }
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
}
