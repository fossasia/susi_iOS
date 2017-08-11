//
//  CustomTextField.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-11.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    // MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    private func commonInit() {
        layer.cornerRadius = 5
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 0.5
        clipsToBounds = true
    }

}
