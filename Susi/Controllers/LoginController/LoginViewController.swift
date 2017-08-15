//
//  LoginViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material
import M13Checkbox
import RealmSwift
import Toast_Swift
import Localize_Swift

class LoginViewController: UIViewController {

    @IBOutlet weak var susiLogo: UIImageView!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var personalServerButton: M13Checkbox!
    @IBOutlet weak var loginButton: RaisedButton!
    @IBOutlet weak var forgotPassword: FlatButton!
    @IBOutlet weak var skipButton: FlatButton!
    @IBOutlet weak var signUpButton: FlatButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var addressTextField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.statusBarStyle = .lightContent

        setupTheme()
        addTapGesture()
        prepareEmailField()
        preparePasswordField()
        prepareLoginButton()
        prepareSkipButton()
        prepareAddressField()
        checkSession()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setText()
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
    }
    
    // Remove the LCLLanguageChangeNotification on viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }


}
