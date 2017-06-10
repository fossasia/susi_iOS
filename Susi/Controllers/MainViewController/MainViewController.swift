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
import RSKGrowingTextView
import RSKPlaceholderTextView
import CoreLocation
import AlamofireImage
import AVFoundation

class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate, UIImagePickerControllerDelegate {

    var messages: [MessageOld] = []

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

    var bottomConstraintTextView: NSLayoutConstraint?
    var bottomConstraintSendButton: NSLayoutConstraint?

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

        initSnowboy()
        startHotwordRecognition()
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

            if message.responseType == MessageOld.ResponseTypes.map {
                return CGSize(width: view.frame.width, height: estimatedFrame.height + 240)
            } else if message.responseType == MessageOld.ResponseTypes.websearch {
                return CGSize(width: view.frame.width, height: estimatedFrame.height + 20 + 64)
            } else if message.responseType == MessageOld.ResponseTypes.image {
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

    // Setup Input Text View
    lazy var inputTextView: RSKGrowingTextView = {
        let textView = RSKGrowingTextView()
        textView.placeholder = ControllerConstants.askSusi as NSString
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.backgroundColor = .white
        textView.maximumNumberOfLines = 2
        textView.layer.cornerRadius = 15
        return textView
    }()

    // Setup Send Button
    lazy var sendButton: FABButton = {
        let button = FABButton()
        button.setImage(UIImage(named: ControllerConstants.send), for: .normal)
        button.backgroundColor = UIColor.defaultColor()
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()

    // Snowboy
    let RESOURCE = Bundle.main.path(forResource: "common", ofType: "res")
    let MODEL = Bundle.main.path(forResource: "susi", ofType: "pmdl")

    var wrapper: SnowboyWrapper! = nil

    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var soundFileURL: URL!

    var timer: Timer!

}
