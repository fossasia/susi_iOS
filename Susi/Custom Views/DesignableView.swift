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

    @IBInspectable var borderViewWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderViewWidth
        }
    }

    @IBInspectable var borderViewColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderViewColor.cgColor
        }
    }

    @IBInspectable var cornerViewRedius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerViewRedius
        }
    }

}
