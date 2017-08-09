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

    // Resign responders
    func resignResponders() {
        view.endEditing(true)
    }

    // Setup Navigation Bar
    func setupTitle() {
        navigationItem.title = ControllerConstants.susiTitle
        navigationItem.titleLabel.textAlignment = .left
        navigationItem.rightViews = [settingsButton]
    }

    // Setup View
    func setupView() {
        showSettingsButton()
    }

    // Shows Youtube Player
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

    func handleDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.removeFromSuperview()
        }, completion: nil)
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
                            self.removeActivityIndicator()
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

    func removeActivityIndicator() {
        if messages.last?.actionType == ActionType.indicatorView.rawValue {
            let item = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.deleteItems(at: [item])
            messages.removeLast()
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
        if messages.count > 0 {
            let lastItem = messages.count - 1
            let indexPath = IndexPath(item: lastItem, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }

    func estimatedFrame(messageBody: String) -> CGRect {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: messageBody).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }

    func loadMessages() {
        messages = List<Message>(realm.objects(Message.self))
        collectionView?.reloadData()
        scrollToLast()
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

    func setupTheme() {
        UIApplication.shared.statusBarStyle = .lightContent
        settingsButton.tintColor = .white
        let activeTheme = UserDefaults.standard.string(forKey: ControllerConstants.UserDefaultsKeys.theme)
        if activeTheme == theme.light.rawValue {
            sendButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#4184F3")
            navigationItem.titleLabel.textColor = .black
            UIApplication.shared.statusBarView?.backgroundColor = UIColor.hexStringToUIColor(hex: "#4184F3")
            settingsButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#4184F3")
            view.backgroundColor = UIColor.hexStringToUIColor(hex: "#EEEEEE")
        } else if activeTheme == theme.dark.rawValue {
            navigationItem.titleLabel.textColor = .white
            sendButton.backgroundColor = UIColor.defaultColor()
            UIApplication.shared.statusBarView?.backgroundColor = UIColor.defaultColor()
            settingsButton.backgroundColor = UIColor.defaultColor()
            view.backgroundColor = UIColor.hexStringToUIColor(hex: "#ECE5DD")
        }
    }

    func showSettingsButton() {
        view.addSubview(settingsButton)
        view.addConstraintsWithFormat(format: "H:[v0(36)]-8-|", views: settingsButton)
        view.addConstraintsWithFormat(format: "V:|-28-[v0(36)]", views: settingsButton)
    }

    func presentSettingsController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsController")
        let nvc = AppNavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
//        let settingsController = SettingsViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        let nvc = AppNavigationController(rootViewController: settingsController)
//        present(nvc, animated: true, completion: nil)
    }

    // Check if user defaults have an image data saved else return nil/Any
    func getWallpaperFromUserDefaults() -> Any? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: ControllerConstants.UserDefaultsKeys.wallpaper)
    }

    // Set chat background image
    func setBackgroundImage(image: UIImage!) {
        let bgView = UIImageView()
        bgView.contentMode = .scaleAspectFill
        bgView.image = image
        collectionView?.backgroundView = bgView
    }

    func setupWallpaper() {
        // Check if user defaults have an image, set background as image
        if let userDefaultData = getWallpaperFromUserDefaults() {
            if let imageData = userDefaultData as? Data { // Check if object exists
                setBackgroundImage(image: UIImage(data : imageData))
            }
        } else {
            collectionView?.backgroundView = nil
        }
    }

    func checkAndAssignIfModelExists() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = dir.appendingPathComponent(ControllerConstants.hotwordFileName)
            if FileManager.default.fileExists(atPath: filePath.path) {
                MODEL = filePath.path
            }
        }
        MODEL = Bundle.main.path(forResource: "susi", ofType: "pmdl")!
    }

}
