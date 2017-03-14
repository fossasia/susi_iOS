//
//  GrowingTextView.swift
//  Pods
//
//  Created by Kenneth Tsang on 17/2/2016.
//  Copyright (c) 2016 Kenneth Tsang. All rights reserved.
//
import Foundation
import UIKit

@objc public protocol GrowingTextViewDelegate: UITextViewDelegate {
    @objc optional func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat)
}

@objc open class GrowingTextView: UITextView {
    
    // Maximum length of text. 0 means no limit.
    open var maxLength = 0
    
    // Trim white space and newline characters when end editing. Default is true
    open var trimWhiteSpaceWhenEndEditing = true
    
    // Maximm height of the textview
    open var maxHeight = CGFloat(0)
    
    // Placeholder properties
    // Need to set both placeHolder and placeHolderColor in order to show placeHolder in the textview
    open var placeHolder: NSString? {
        didSet { setNeedsDisplay() }
    }
    open var placeHolderColor: UIColor? {
        didSet { setNeedsDisplay() }
    }
    open var placeHolderLeftMargin: CGFloat = 5 {
        didSet { setNeedsDisplay() }
    }
    
    override open var text: String! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    fileprivate weak var heightConstraint: NSLayoutConstraint?
    
    // Initialize
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // Listen to UITextView notification to handle trimming, placeholder and maximum length
    fileprivate func commonInit() {
        
        self.contentMode = .redraw
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing), name: NSNotification.Name.UITextViewTextDidEndEditing, object: self)
    }
    
    // Remove notification observer when deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Calculate height of textview
    override open func layoutSubviews() {
        super.layoutSubviews()
        let size = sizeThatFits(CGSize(width:bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
        var height = size.height
        if maxHeight > 0 {
            height = min(size.height, maxHeight)
        }
        
        if (heightConstraint == nil) {
            heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
            addConstraint(heightConstraint!)
        }
        
        if height != heightConstraint?.constant {
            self.heightConstraint!.constant = height;
            scrollRangeToVisible(NSMakeRange(0, 0))
            if let delegate = delegate as? GrowingTextViewDelegate {
                delegate.textViewDidChangeHeight!(self, height: height)
            }
        }
    }
    
    // Show placeholder
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        if text.isEmpty {
            guard let placeHolder = placeHolder else { return }
            guard let placeHolderColor = placeHolderColor else { return }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = textAlignment
            
            let rect = CGRect(x: textContainerInset.left + placeHolderLeftMargin,
                              y: textContainerInset.top,
                              width:   frame.size.width - textContainerInset.left - textContainerInset.right,
                              height: frame.size.height)
            
            var attributes = [
                NSForegroundColorAttributeName: placeHolderColor,
                NSParagraphStyleAttributeName: paragraphStyle
            ]
            if let font = font {
                attributes[NSFontAttributeName] = font
            }
            
            placeHolder.draw(in: rect, withAttributes: attributes)
        }
    }
    
    // Trim white space and new line characters when end editing.
    func textDidEndEditing(notification: Notification) {
        if let notificationObject = notification.object as? GrowingTextView {
            if notificationObject === self {
                if trimWhiteSpaceWhenEndEditing {
                    text = text?.trimmingCharacters(in: .whitespacesAndNewlines)
                    setNeedsDisplay()
                }
            }
        }
    }
    
    // Limit the length of text
    func textDidChange(notification: Notification) {
        if let notificationObject = notification.object as? GrowingTextView {
            if notificationObject === self {
                if maxLength > 0 && text.characters.count > maxLength {
                    
                    let endIndex = text.index(text.startIndex, offsetBy: maxLength)
                    text = text.substring(to: endIndex)
                    undoManager?.removeAllActions()
                }
                setNeedsDisplay()
            }
        }
    }
}
