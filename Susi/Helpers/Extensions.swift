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

    static func hexStringToUIColor(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if cString.count != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }

}

extension String {

    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    func isImage() -> Bool {
        let imageFormats = ["jpg", "jpeg", "png", "gif"]

        if let ext = self.getExtension() {
            return imageFormats.contains(ext)
        }

        return false
    }

    func getExtension() -> String? {
        let ext = (self as NSString).pathExtension

        if ext.isEmpty {
            return nil
        }

        return ext
    }

    func isURL() -> Bool {
        return URL(string: self) != nil
    }

    func isValidURL() -> Bool {
        if let url = URL(string: self) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }

    func containsURL() -> Bool {
        var isValid = false

        if !self.contains("..") {
            let head       = "((http|https)://)?([(w|W)]{3}+\\.)?"
            let tail       = "\\.+[A-Za-z]{2,3}+(\\.)?+(/(.)*)?"

            let urlRegEx = head+"+(.)+"+tail

            let urlTest = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
            isValid = urlTest.evaluate(with: self.trimmed)
        }
        return isValid
    }

    func extractFirstURL() -> String {
        if self.containsURL() {
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))

            for match in matches {
                let url = (self as NSString).substring(with: match.range)
                return url
            }
        }
        return ""
    }

    var html2AttributedString: NSAttributedString? {
        do {
            let docType = NSAttributedString.DocumentType.html
            let charEncoding = String.Encoding.utf8.rawValue
            return try NSAttributedString(data: Data(utf8),
                                          options: [NSAttributedString.DocumentReadingOptionKey.documentType: docType, NSAttributedString.DocumentReadingOptionKey.characterEncoding: charEncoding],
                                          documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }

    var html2String: String {
        return html2AttributedString?.string ?? ""
    }

    // Password validation
    var isTextSufficientComplexity: Bool {

        let capitalLetterRegEx  = ".*[A-Z]+.*"
        var texttest = NSPredicate(format: "SELF MATCHES %@", capitalLetterRegEx)
        let capitalResult = texttest.evaluate(with: self)

        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        let numberResult = texttest1.evaluate(with: self)

        let lowercaseLetterRegEx  = ".*[a-z]+.*"
        texttest = NSPredicate(format: "SELF MATCHES %@", lowercaseLetterRegEx)
        let lowercaseResult = texttest.evaluate(with: self)

        return capitalResult && numberResult && lowercaseResult

    }

    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }

    func getFirstTwoChar() -> String {
        return String(self.prefix(2))
    }

    func getFirstChar(_ char: Int) -> String {
        return String(self.prefix(char))
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

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }

    // Define UI margin constants
    struct UIMarginSpec {
        static let smallMargin: CGFloat = 10.0
        static let mediumMargin: CGFloat = 20.0
        static let largeMatgin: CGFloat = 40.0
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

extension NSMutableAttributedString {

    public func setAsLink(textToFind: String, linkURL: String, text: String) -> Bool {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedString.Key.link, value: linkURL, range: foundRange)
            self.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)], range: self.mutableString.range(of: text))
            return true
        }
        return false
    }

}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension UILabel {

    func heightForLabel(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }

}

extension UIButton {

    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 10, left: -insetAmount, bottom: 10, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }

}

extension Int {

    func percentage(outOf totalNumber: Int) -> Double {
        return ((Double(self)/Double(totalNumber)) * 100).truncate(places: 1)
    }

}

extension Double {

    func truncate(places: Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }

}
