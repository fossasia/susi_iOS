//
//  AccountViewController.swift
//  Susi
//
//  Created by Syed on 28/05/19.
//  Copyright © 2019 FOSSAsia. All rights reserved.
//

import UIKit
import Material

class AccountViewController: UIViewController {
    
    
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

    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setUpUserDetails()
    }
    
    
}
