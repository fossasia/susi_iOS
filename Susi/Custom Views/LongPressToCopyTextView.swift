//
//  LongPressToCopyTextView.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-21.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

class LongPressToCopyTextView: UITextView {

    var url: String?

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return (action == #selector(UIResponderStandardEditActions.copy(_:)))
    }

    // MARK: - UIResponderStandardEditActions

    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
    }

    func addTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(sender:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }


    // MARK: - UIGestureRecognizer
    @objc func handleTapGesture(sender: UITapGestureRecognizer) {
        guard let strUrl = url  else { return }
        let textView = UITextView(frame: self.frame)
        textView.text = self.text
        textView.attributedText = self.attributedText
        if let linkedRange = self.attributedText.string.range(of: strUrl) {
            let index = textView.layoutManager.characterIndex(for: sender.location(in: self),
                                                              in: textView.textContainer,
                                                              fractionOfDistanceBetweenInsertionPoints: nil)
            if linkedRange.lowerBound.encodedOffset <= index && linkedRange.upperBound.encodedOffset >= index {
                if let url = URL(string: strUrl) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }

    func addLongPressGesture() {
        self.isUserInteractionEnabled = true
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(recognizer:)))
        self.addGestureRecognizer(gestureRecognizer)
    }

    // MARK: - UIGestureRecognizer

    @objc func handleLongPressGesture(recognizer: UIGestureRecognizer) {
        guard recognizer.state == .recognized else { return }

        if let recognizerView = recognizer.view,
            let recognizerSuperView = recognizerView.superview, recognizerView.becomeFirstResponder() {
            let menuController = UIMenuController.shared
            menuController.setTargetRect(recognizerView.frame, in: recognizerSuperView)
            menuController.setMenuVisible(true, animated: true)
        }
    }

}
