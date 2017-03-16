//
//  Extensions.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}


extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

class AuthTextField: ErrorTextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        detailColor = .red
        isClearIconButtonEnabled = true
        placeholderNormalColor = .white
        placeholderActiveColor = .white
        dividerNormalColor = .white
        dividerActiveColor = .white
        textColor = .white
        clearIconButton?.tintColor = .white
        isErrorRevealed = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
