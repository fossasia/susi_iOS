//
//  AccountViewController.swift
//  Susi
//
//  Created by Syed on 28/05/19.
//  Copyright © 2019 FOSSAsia. All rights reserved.
//

import UIKit
import Material

class AccountViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    lazy var backButton: IconButton = {
        let ib = IconButton()
        ib.image = Icon.cm.arrowBack
        ib.tintColor = .white
        ib.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return ib
    }()
    
    lazy var settingsButton: IconButton = {
        let ib = IconButton()
        ib.image = Icon.check
        ib.tintColor = .white
        ib.layer.cornerRadius = 18.0
        ib.addTarget(self, action: #selector(settingButtonClicked), for: .touchUpInside)
        return ib
    }()
   
    var picker = UIPickerView()
    
    var preferredLanguage = ["Armenian (am-AM)","Chinese (zh-CH)","Deutsch (de-DE)"," Greek (gr-GR)","Hindi (hi-IN) ","Punjabi (pb-IN)","Nepali (np-NP)","Russian (ru-RU)","Spanish (es-SP)","French (fr-FR)","apanese (jp-JP) ","Dutch (nl-NL)","US Eng (en-US)"]

    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var prefLanguageTextField: TextField!
    @IBOutlet weak var phoneNumberTextField: TextField!
    @IBOutlet weak var userNameTextField: TextField!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setUpUserDetails()
        addDelegates()
    }
    
    //UIPickerView Deledate Functions
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return preferredLanguage.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return preferredLanguage[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        prefLanguageTextField.text = preferredLanguage[row]
        self.view.endEditing(false)
    }

}
