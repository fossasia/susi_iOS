//
//  MainViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material
import Popover
import ALTextInputBar
import CoreLocation
import AlamofireImage

class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ALTextInputBarDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate {

    var messages: [Message] = []

    var popover: Popover!
    var popoverOptions: [PopoverOption] = [
        .type(.down),
        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6)),
        .arrowSize(CGSize(width: 12.0, height: 10.0))
    ]

    // Search Button Configure
    let searchButton: IconButton = {
        let ib = IconButton()
        ib.image = Icon.cm.search
        ib.tintColor = .white
        return ib
    }()

    // Settings Button Configure
    lazy var settingsButton: IconButton = {
        let image = Icon.cm.moreVertical
        let ib = IconButton()
        ib.image = image
        ib.addTarget(self, action: #selector(showSettingsView), for: .touchUpInside)
        ib.tintColor = .white
        return ib
    }()

    // Location Manager
    var locationManager = CLLocationManager()
    // Image Picker Controller
    var imagePicker = UIImagePickerController()
    let blackView = UIView()

    // Youtube Player
    lazy var youtubePlayer: YouTubePlayerView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 16, height: self.view.frame.height * 1 / 3)
        let player = YouTubePlayerView(frame: frame)
        return player
    }()

    var bottomConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTitle()
        setupView()
        setupCollectionView()
        setupInputComponents()

        // Dismiss keyboard when touched anywhere in CV
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignResponders)))

        subscribeToKeyboardNotifications()

        // Configure Location Manager
        configureLocationManager()
    }

    // Number of items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // print("Number of messages: \(messages.count)")
        return messages.count
    }

    // Configure Cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let message = messages[indexPath.row]

        let messageText = message.body
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText!).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)

        if message.isBot {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControllerConstants.incomingCell, for: indexPath) as! IncomingBubbleCell
            cell.message = message
            cell.setupCell(estimatedFrame, view.frame, message)
            cell.layoutSubviews()
            cell.layoutIfNeeded()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControllerConstants.outgoingCell, for: indexPath) as! OutgoingChatCell
            cell.message = message
            cell.setupCell(estimatedFrame, view.frame)
            cell.layoutSubviews()
            cell.layoutIfNeeded()
            return cell
        }
    }

    // Calculate Bubble Height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = messages[indexPath.row]

        if let messageText = message.body {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)

            if message.responseType == Message.ResponseTypes.map {
                return CGSize(width: view.frame.width, height: estimatedFrame.height + 240)
            } else if message.responseType == Message.ResponseTypes.websearch {
                return CGSize(width: view.frame.width, height: estimatedFrame.height + 20 + 64)
            } else if message.responseType == Message.ResponseTypes.image {
                return CGSize(width: view.frame.width, height: 150)
            }

            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }

        return CGSize(width: view.frame.width, height: 100)
    }

    // Set Edge Insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }

    // Setup Message Container
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()

    // Setup Input Text Field
    lazy var inputTextField: ALTextInputBar = {
        let textField = ALTextInputBar()
        textField.textView.placeholder = ControllerConstants.askSusi
        textField.textView.font = UIFont.systemFont(ofSize: 17)
        textField.backgroundColor = .clear
        textField.textView.maxNumberOfLines = 2
        textField.delegate = self
        return textField
    }()

    // Setup Send Button
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(ControllerConstants.send, for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()

}
