//
//  MainVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import RealmSwift

extension ChatViewController {

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func unsubscriveToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func handleKeyboardNotification(notification: NSNotification) {

        if let userInfo = notification.userInfo {

            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow

            bottomConstraintTextView?.constant = isKeyboardShowing ? (-keyboardFrame!.height - 8.0) : 0
            bottomConstraintSendButton?.constant = isKeyboardShowing ? (-keyboardFrame!.height - 8.0) : 0

            collectionView?.frame = isKeyboardShowing ? CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - keyboardFrame!.height - 47) :
                CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 47)

            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {

                self.view.layoutIfNeeded()

            }, completion: { (_) in

                if isKeyboardShowing {
                    self.scrollToLast()
                }

            })
        }
    }

    // Resign responders
    func resignResponders() {
        self.view.endEditing(true)
    }

    // Setup Navigation Bar
    func setupTitle() {
        navigationItem.title = ControllerConstants.susiTitle
        navigationItem.titleLabel.textAlignment = .left
        navigationItem.titleLabel.textColor = .white

        navigationItem.rightViews = [searchButton, settingsButton]
    }

    // Setup View
    func setupView() {
        self.view.backgroundColor = UIColor.rgb(red: 236, green: 229, blue: 221)
    }

    // Shows Youtube Player
    func addYotubePlayer(_ videoID: String) {
        if let window = UIApplication.shared.keyWindow {
            blackView.frame = window.frame
            self.view.addSubview(blackView)
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))

            self.blackView.addSubview(self.youtubePlayer)
            let centerX = UIScreen.main.bounds.size.width / 2
            let centerY = UIScreen.main.bounds.size.height / 3
            self.youtubePlayer.center = CGPoint(x: centerX, y: centerY)
            self.youtubePlayer.loadVideoID(videoID)

            blackView.alpha = 0
            youtubePlayer.alpha = 0

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.youtubePlayer.alpha = 1
            }, completion: nil)
        }
    }

    func handleDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.removeFromSuperview()
        }, completion: nil)
    }

    // Setup Collection View
    func setupCollectionView() {
        // Check if user defaults have an image, set background as image
        if let userDefaultData = getWallpaperFromUserDefaults() {
            if let imageData = userDefaultData as? Data { // Check if object saved in user defaults if of type Data
                setBackgroundImage(image: UIImage(data : imageData))
            }
        }
        collectionView?.backgroundColor = .clear
        collectionView?.delegate = self
        collectionView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 47)
        collectionView?.register(IncomingBubbleCell.self, forCellWithReuseIdentifier: ControllerConstants.incomingCell)
        collectionView?.register(OutgoingChatCell.self, forCellWithReuseIdentifier: ControllerConstants.outgoingCell)
        collectionView?.register(RSSCell.self, forCellWithReuseIdentifier: ControllerConstants.rssCell)
        collectionView?.register(ActivityIndicatorCell.self, forCellWithReuseIdentifier: ControllerConstants.indicatorCell)
        collectionView?.accessibilityIdentifier = ControllerConstants.TestKeys.chatCollectionView
    }

    // Send Button Action
    func handleSend() {
        if let text = inputTextView.text, text.characters.count > 0 && !text.isEmpty {
            var params: [String : AnyObject] = [
                Client.WebsearchKeys.Query: text as AnyObject,
                Client.ChatKeys.TimeZoneOffset: ControllerConstants.timeZone as AnyObject,
                Client.ChatKeys.Language: Locale.current.languageCode as AnyObject
            ]

            saveMessage(text)
            addActivityIndicatorMessage()

            if let location = locationManager.location {
                params[Client.ChatKeys.Latitude] = location.coordinate.latitude as AnyObject
                params[Client.ChatKeys.Longitude] = location.coordinate.longitude as AnyObject
            }

            if let userData = UserDefaults.standard.dictionary(forKey: ControllerConstants.UserDefaultsKeys.user) as [String : AnyObject]? {
                let user = User(dictionary: userData)
                params[Client.ChatKeys.AccessToken] = user.accessToken as AnyObject
            }

            Client.sharedInstance.queryResponse(params) { (messages, success, _) in
                DispatchQueue.main.async {
                    if success {
                        self.collectionView?.performBatchUpdates({
                            let item = IndexPath(item: self.messages.count - 1, section: 0)
                            self.collectionView?.deleteItems(at: [item])
                            self.messages.removeLast()
                            for message in messages! {
                                try! self.realm.write {
                                    self.realm.add(message)
                                    self.messages.append(message)
                                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                                    self.collectionView?.insertItems(at: [indexPath])
                                    if message.actionType == ActionType.answer.rawValue {
                                        self.speakAction(message.message, language: message.answerData?.language)
                                    }
                                }
                            }
                        }, completion: { (_) in
                            self.scrollToLast()
                        })
                    }
                }
            }
        }
    }

    func addActivityIndicatorMessage() {
        let message = Message()
        message.actionType = ActionType.indicatorView.rawValue
        self.messages.append(message)
        let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
        self.collectionView?.insertItems(at: [indexPath])
    }

    // Setup Input Components
    func setupInputComponents() {

        view.addSubview(inputTextView)
        view.addSubview(sendButton)

        view.layout(sendButton).bottomRight(bottom: 8.0, right: 8.0).width(40).height(40)
        view.layout(inputTextView).bottomLeft(bottom: 8.0, left: 8.0).width(view.frame.width - 64)

        bottomConstraintTextView = NSLayoutConstraint(item: inputTextView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraintTextView!)

        bottomConstraintSendButton = NSLayoutConstraint(item: sendButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraintSendButton!)
    }

    // Temporarily save message to object
    func saveMessage(_ message: String) {

        let message = Message(message: message.trimmed)

        try! realm.write {
            realm.add(message)
            messages.append(message)
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.insertItems(at: [indexPath])
            self.scrollToLast()

            self.sendButton.tag = 0
            self.inputTextView.text = ""
            setImageForSendButton()
        }
    }

    // Scroll to last message
    func scrollToLast() {
        if self.messages.count > 0 {
            let lastItem = self.messages.count - 1
            let indexPath = IndexPath(item: lastItem, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }

    func estimatedFrame(messageBody: String) -> CGRect {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: messageBody).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }

    func loadMessages() {
        self.messages = List<Message>(realm.objects(Message.self))
        self.collectionView?.reloadData()
        self.scrollToLast()
    }

    func getMessagesFromMemory() {
        if let userData = UserDefaults.standard.dictionary(forKey: ControllerConstants.UserDefaultsKeys.user) {
            let user = User(dictionary: userData as [String : AnyObject])

            let params = [
                Client.UserKeys.AccessToken: user.accessToken
            ]

            Client.sharedInstance.getMessagesFromMemory(params as [String : AnyObject]) { (messages, _, _) in
                DispatchQueue.main.async {
                    self.collectionView?.performBatchUpdates({
                        for message in messages! {
                            try! self.realm.write {
                                self.realm.add(message)
                                self.messages.append(message)
                                let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                                self.collectionView?.insertItems(at: [indexPath])
                            }
                        }
                    }, completion: { (_) in
                        self.scrollToLast()
                    })
                }
            }

        }
    }

    func setTargetForSendButton() {
        if isSpeechRecognitionRunning {
            stopSTT()
            setImageForSendButton()
        } else {
            if sendButton.tag == 0 {
                startSTT()
            } else {
                handleSend()
            }
        }
    }

    func setImageForSendButton() {
        if !isSpeechRecognitionRunning {
            if let text = inputTextView.text, text.isEmpty {
                sendButton.setImage(UIImage(named: ControllerConstants.mic), for: .normal)
            } else {
                sendButton.setImage(UIImage(named: ControllerConstants.send), for: .normal)
            }
        }
    }

}
