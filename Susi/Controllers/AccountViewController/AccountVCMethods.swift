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
    }
}
