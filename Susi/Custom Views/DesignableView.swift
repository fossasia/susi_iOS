//
//  DesignableView.swift
//  Susi
//
//  Created by JOGENDRA on 30/05/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableView: UIView {

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var cornerRedius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRedius
        }
    }

}
