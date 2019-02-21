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

protocol ChatViewControllerProtocol: class {
    func searchWith(text: String?)
}
extension ChatViewController {

    // MARK: - Keyboard Notifications

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:
            #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscriveToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func handleKeyboardNotification(notification: NSNotification) {

        if let userInfo = notification.userInfo {

            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification

            if #available(iOS 11.0, *) {
                bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height + view.safeAreaInsets.bottom : 0
            } else {
                bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
            }

            collectionView?.frame = isKeyboardShowing ? CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height - keyboardFrame!.height - 71) :
                CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height - 71)

            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {

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
    @objc func resignResponders() {
        view.endEditing(true)
    }

    // setup navigation bar
    func setupNavbar() {
        navigationItem.titleLabel.text = ControllerConstants.susiTitle.localized()
        navigationItem.titleLabel.textAlignment = .left
    }

    // setup view
    func setupView() {
        UIApplication.shared.statusBarStyle = .lightContent
        navigationItem.titleLabel.textColor = .black
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.defaultColor()
        view.backgroundColor = UIColor.chatBackgroundColor()
    }

    // setup send button
    func setupSendButton() {
        indicatorView.stopAnimating()
        sendButton.addSubview(indicatorView)
        sendButton.addConstraintsWithFormat(format: "V:|-12-[v0(16)]-12-|", views: indicatorView)
        sendButton.addConstraintsWithFormat(format: "H:|-12-[v0(16)]-12-|", views: indicatorView)

        // add gesture recogniser
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(setTargetForSendButton))
        gesture.numberOfTapsRequired = 1
        indicatorView.addGestureRecognizer(gesture)
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

        if #available(iOS 11.0, *) {
            bottomConstraint = NSLayoutConstraint(item: messageInputContainerView,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: view.safeAreaLayoutGuide,
                                                  attribute: .bottom, multiplier: 1, constant: 0)
        } else {
            // Fallback on earlier versions
            bottomConstraint = NSLayoutConstraint(item: messageInputContainerView,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: view,
                                                  attribute: .bottom, multiplier: 1, constant: 0)
        }
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

    // setup skill listing button
    func addSkillListingButton() {
        view.addSubview(susiSkillListingButton)
        view.addConstraintsWithFormat(format: "H:[v0(36)]-8-|", views: susiSkillListingButton)
        let height = UIApplication.shared.statusBarFrame.size.height
        view.addConstraintsWithFormat(format: "V:|-\(Int(height) + 4)-[v0(36)]", views: susiSkillListingButton)
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
        if let text = inputTextField.text, text.count > 0 && !text.isEmpty {
            var params: [String: AnyObject] = [
                Client.WebsearchKeys.Query: text as AnyObject,
                Client.ChatKeys.TimeZoneOffset: ControllerConstants.timeZone as AnyObject,
                Client.ChatKeys.Language: Locale.current.languageCode as AnyObject,
                Client.ChatKeys.deviceType: ControllerConstants.deviceType as AnyObject
            ]

            UserDefaults.standard.set(text, forKey: ControllerConstants.UserDefaultsKeys.userQuery)
            saveMessage(text)
            addActivityIndicatorMessage()

            if let location = locationManager.location {
                params[Client.ChatKeys.Latitude] = location.coordinate.latitude as AnyObject
                params[Client.ChatKeys.Longitude] = location.coordinate.longitude as AnyObject
            }

            if let delegate = UIApplication.shared.delegate as? AppDelegate, let user = delegate.currentUser {
                params[Client.ChatKeys.AccessToken] = user.accessToken as AnyObject
            }

            if let countryCode = Locale.current.regionCode {
                params[Client.ChatKeys.CountryCode] = countryCode as AnyObject
                if let countryName = countryName(from: countryCode) {
                    params[Client.ChatKeys.CountryName] = countryName as AnyObject
                }
            }

            Client.sharedInstance.queryResponse(params) { (messages, success, _) in
                DispatchQueue.main.async {
                    if let messages = messages, success {
                        self.addMessagesToCollectionView(messages: messages)
                    } else {
                        self.collectionView?.performBatchUpdates({
                            self.removeActivityIndicator()
                        }, completion: nil)
                    }
                }
            }
        }
    }

    // Get county name from country code
    func countryName(from countryCode: String) -> String? {
        let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode)
            // Country name was found
            return name
    }

    // downloads messages from user history
    func getMessagesFromMemory() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate, let user = delegate.currentUser {
            let params = [
                Client.UserKeys.AccessToken: user.accessToken
            ]

            Client.sharedInstance.getMessagesFromMemory(params as [String: AnyObject]) { (messages, _, _) in
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
                    UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.collectionView?.insertItems(at: [indexPath])
                        if message.actionType == ActionType.answer.rawValue && !message.fromUser {
                            self.speakAction(message)
                        } else if message.actionType == ActionType.stop.rawValue && !message.fromUser {
                            self.stopSpeakAction()
                        }
                    }, completion: nil)
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

    @objc func setTargetForSendButton() {
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
                sendButton.setImage(ControllerConstants.Images.microphone, for: .normal)
                sendButton.tintColor = UIColor.defaultColor()
                sendButton.backgroundColor = .clear
            } else {
                sendButton.setImage(ControllerConstants.Images.send, for: .normal)
                sendButton.tintColor = .white
                sendButton.backgroundColor = UIColor.defaultColor()
            }
        }
    }

    func checkReachability() {
        reachability.whenReachable = { reachability in
            self.setUIBasedOnReachability(value: true)
        }
        reachability.whenUnreachable = { reachability in
            self.setUIBasedOnReachability(value: false)
        }
    }

    func setUIBasedOnReachability(value: Bool) {
        DispatchQueue.main.async {
            self.inputTextField.isEditable = value
            if value {
                self.alert.dismiss(animated: true, completion: nil)
            } else {
                self.present(self.alert, animated: true, completion: nil)
            }
        }
    }
    func shouldOpenSkillListingVC() {
        if(self.shouldOpenSkillListing) {
            self.shouldOpenSkillListing = false
            presentSkillListingController()
        }
    }
    // present skill listing controller
    @objc func presentSkillListingController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = mainStoryboard.instantiateViewController(withIdentifier: "SkillListingController") as? SkillListingViewController {
            vc.chatViewControllerDelegate = self
            let nvc = AppNavigationController(rootViewController: vc)
            present(nvc, animated: true, completion: nil)
        }
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

    // dismiss keyboard when touched anywhere in CV
    func addGestures() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignResponders)))
    }

    // scroll to last message
    @objc func scrollToLast() {
        if messages.count > 0 {
            let lastItem = messages.count - 1
            let indexPath = IndexPath(item: lastItem, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
            scrollButton.isHidden = true
        }
    }

    // estimates frame of message
    func estimatedFrame(message: String) -> CGRect {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: message).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }

    // loads all messages from database
    func loadMessages() {
        messages = Array(realm.objects(Message.self))
        collectionView?.reloadData()
        scrollToLast()
    }

}

extension ChatViewController: PresentControllerDelegate {

    func loadNewScreen(controller: UIViewController) {
        self.present(controller, animated: true, completion: nil)
    }

}

extension ChatViewController: ChatViewControllerProtocol {
    func searchWith(text: String?) {
        guard let text = text else { return }
        self.inputTextField.text = text
        self.handleSend()
    }
}
