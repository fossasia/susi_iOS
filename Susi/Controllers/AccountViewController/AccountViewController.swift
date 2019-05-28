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
    
    lazy var backButton: IconButton = {
        let ib = IconButton()
        ib.image = Icon.cm.arrowBack
        ib.tintColor = .white
        ib.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return ib
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
    }
    

}
