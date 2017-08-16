//
//  ChatVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import RealmSwift
import Material

extension ChatViewController {

    // MARK: - Keyboard Notifications

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

            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height : 0

            collectionView?.frame = isKeyboardShowing ? CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height - keyboardFrame!.height - 71) :
                CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height - 71)

            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {

                self.view.layoutIfNeeded()

            }, completion: { (_) in

                if isKeyboardShowing {
                    self.scrollToLast()
                }

            })
        }
    }

    // MARK: - Configure Views

    // Resign responders
    func resignResponders() {
        view.endEditing(true)
    }

    // setup navigation bar
    func setupNavbar() {
        navigationItem.title = ControllerConstants.susiTitle
        navigationItem.titleLabel.textAlignment = .left
        navigationItem.rightViews = [settingsButton]
    }

    // setup view
    func setupView() {
        UIApplication.shared.statusBarStyle = .lightContent
        settingsButton.tintColor = .white
        sendButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#4184F3")
        navigationItem.titleLabel.textColor = .black
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.hexStringToUIColor(hex: "#4184F3")
        settingsButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#4184F3")
        view.backgroundColor = UIColor.hexStringToUIColor(hex: "#EEEEEE")

    }

    // shows youtube player
    func addYotubePlayer(_ videoID: String) {
        if let window = UIApplication.shared.keyWindow {
            blackView.frame = window.frame
            view.addSubview(blackView)
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))

            blackView.addSubview(youtubePlayer)
            let centerX = UIScreen.main.bounds.size.width / 2
            let centerY = UIScreen.main.bounds.size.height / 3
            youtubePlayer.center = CGPoint(x: centerX, y: centerY)
            youtubePlayer.loadVideoID(videoID)

            blackView.alpha = 0
            youtubePlayer.alpha = 0

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.youtubePlayer.alpha = 1
            }, completion: nil)
        }
    }

    func addActivityIndicatorMessage() {
        removeActivityIndicator()
        let message = Message()
        message.actionType = ActionType.indicatorView.rawValue
        messages.append(message)
        let indexPath = IndexPath(item: messages.count - 1, section: 0)
        collectionView?.insertItems(at: [indexPath])
        scrollToLast()
    }

    func removeActivityIndicator() {
        if messages.last?.actionType == ActionType.indicatorView.rawValue {
            let item = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.deleteItems(at: [item])
            messages.removeLast()
        }
    }

    // setup input components
    func setupInputComponents() {
        view.addSubview(messageInputContainerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: messageInputContainerView)
        view.addConstraintsWithFormat(format: "V:[v0(48)]", views: messageInputContainerView)

        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)

        // chat container view configuration
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)

        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(topBorderView)

        messageInputContainerView.addConstraintsWithFormat(format: "H:|-8-[v0][v1(40)]-4-|", views: inputTextField, sendButton)

        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: inputTextField)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|-4-[v0(40)]-4-|", views: sendButton)

        messageInputContainerView.addConstraintsWithFormat(format: "H:|[v0]|", views: topBorderView)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0(0.5)]", views: topBorderView)
    }

    // setup settings button
    func addSettingsButton() {
        view.addSubview(settingsButton)
        view.addConstraintsWithFormat(format: "H:[v0(36)]-8-|", views: settingsButton)
        view.addConstraintsWithFormat(format: "V:|-28-[v0(36)]", views: settingsButton)
    }

    // setup scroll button
    func addScrollButton() {
        view.addSubview(scrollButton)
        view.addConstraintsWithFormat(format: "H:[v0(44)]|", views: scrollButton)
        view.addConstraintsWithFormat(format: "V:[v0(44)]-70-|", views: scrollButton)
        scrollButton.isHidden = true
    }

    // MARK: - Make API calls and use realm database

    // handles the send action on the button
    func handleSend() {
        if let text = inputTextField.text, text.characters.count > 0 && !text.isEmpty {
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
                        if let messages = messages {
                            self.addMessagesToCollectionView(messages: messages)
                        }
                    }
                }
            }
        }
    }

    // downloads messages from user history
    func getMessagesFromMemory() {
        if let userData = UserDefaults.standard.dictionary(forKey: ControllerConstants.UserDefaultsKeys.user) {
            let user = User(dictionary: userData as [String : AnyObject])

            let params = [
                Client.UserKeys.AccessToken: user.accessToken
            ]

            Client.sharedInstance.getMessagesFromMemory(params as [String : AnyObject]) { (messages, _, _) in
                DispatchQueue.main.async {
                    if let messages = messages {
                        self.addMessagesToCollectionView(messages: messages)
                    }
                }
            }

        }
    }

    func addMessagesToCollectionView(messages: List<Message>) {
        self.collectionView?.performBatchUpdates({
            self.removeActivityIndicator()
            for message in messages {
                try! self.realm.write {
                    self.realm.add(message)
                    self.messages.append(message)
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.insertItems(at: [indexPath])
                    if message.actionType == ActionType.answer.rawValue && !self.loadMemoryFromNetwork {
                        self.speakAction(message.message, language: message.answerData?.language)
                    }
                }
            }
        }, completion: { (_) in
            self.scrollToLast()
        })
    }

    // save message to object
    func saveMessage(_ message: String) {
        let message = Message(message: message.trimmed)
        let list = List<Message>()
        list.append(message)
        addMessagesToCollectionView(messages: list)
        self.sendButton.tag = 0
        self.inputTextField.text = ""
        setImageForSendButton()
    }

    // MARK: - Miscellaneous

    func setTargetForSendButton() {
        if isSpeechRecognitionRunning {
            stopSpeechToText()
            setImageForSendButton()
        } else {
            if sendButton.tag == 0 {
                startSpeechToText()
            } else {
                handleSend()
            }
        }
    }

    func setImageForSendButton() {
        if !isSpeechRecognitionRunning {
            if let text = inputTextField.text, text.isEmpty {
                sendButton.setImage(UIImage(named: ControllerConstants.mic), for: .normal)
            } else {
                sendButton.setImage(UIImage(named: ControllerConstants.send), for: .normal)
            }
        }
    }

    // presents the settings controller
    func presentSettingsController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsController")
        let nvc = AppNavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
    }

    // checks if personal trained model exists
    func checkAndAssignIfModelExists() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = dir.appendingPathComponent(ControllerConstants.hotwordFileName)
            if FileManager.default.fileExists(atPath: filePath.path) {
                MODEL = filePath.path
            }
        }
        MODEL = Bundle.main.path(forResource: "susi", ofType: "pmdl")!
    }

    // sets content offset so that messages start displaying from bottom
    func setCollectionViewOffset() {
        view.layoutIfNeeded()

        let contentSize = collectionView?.collectionViewLayout.collectionViewContentSize
        if let contentHeight = contentSize?.height, let collectionViewHeight = collectionView?.bounds.size.height {
            let targetContentOffset = CGPoint(x: 0, y: contentHeight - collectionViewHeight)
            collectionView?.setContentOffset(targetContentOffset, animated: true)
        }
    }

    // dismiss keyboard when touched anywhere in CV
    func addGestures() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignResponders)))
    }

    // dismiss the overlay for the video
    func handleDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.removeFromSuperview()
        }, completion: nil)
    }

    // scroll to last message
    func scrollToLast() {
        if messages.count > 0 {
            let lastItem = messages.count - 1
            let indexPath = IndexPath(item: lastItem, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
            scrollButton.isHidden = true
        }
    }

    // estimates frame of message
    func estimatedFrame(messageBody: String) -> CGRect {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: messageBody).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }

    // loads all messages from database
    func loadMessages() {
        messages = List<Message>(realm.objects(Message.self))
        collectionView?.reloadData()
        scrollToLast()
    }

}
