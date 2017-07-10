//
//  MainVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import CoreLocation
import Popover
import RSKGrowingTextView
import AVFoundation
import RealmSwift

extension MainViewController {

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

    // Setup Settings View
    func showSettingsView() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width / 2), height: (ControllerConstants.Settings.settingsList.count * 44)))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        self.popover = Popover(options: self.popoverOptions)
        self.popover.show(tableView, fromView: settingsButton)
        self.popover.showBlackOverlay = true
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
    }

    // Send Button Action
    func handleSend() {
        if let text = inputTextView.text, text.characters.count > 0 && !text.isEmpty {
            var params: [String : AnyObject] = [
                Client.WebsearchKeys.Query: inputTextView.text! as AnyObject,
                Client.ChatKeys.TimeZoneOffset: ControllerConstants.timeZone as AnyObject,
                Client.ChatKeys.Language: Locale.current.languageCode as AnyObject
            ]

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
            saveMessage()
            params.removeAll()
        }
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
    func saveMessage() {
        let message = Message(message: inputTextView.text.trimmed)

        try! realm.write {
            realm.add(message)
            messages.append(message)
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.insertItems(at: [indexPath])
            self.scrollToLast()

            self.sendButton.tag = 0
            inputTextView.text = ""
            self.textViewDidChange(inputTextView)
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

    func addTargetSendButton() {
//        print("send button tag: \(sendButton.tag)")
        if sendButton.tag == 0 {
            sendButton.removeTarget(self, action: #selector(handleSend), for: .touchUpInside)
            sendButton.addTarget(self, action: #selector(startSTT), for: .touchUpInside)
        } else {
            if audioEngine.isRunning {
                stopSTT()
            }
            sendButton.removeTarget(self, action: #selector(startSTT), for: .touchUpInside)
            sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        }
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

}
