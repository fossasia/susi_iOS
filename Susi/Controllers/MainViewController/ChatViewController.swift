//
//  ChatViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material
import RSKGrowingTextView
import RSKPlaceholderTextView
import CoreLocation
import AVFoundation
import RealmSwift
import Speech
import NVActivityIndicatorView
import Realm

class ChatViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, AVSpeechSynthesizerDelegate {

    var messages = List<Message>()
    let realm = try! Realm()

    var menuOptionNameArray: [String] {
        return ControllerConstants.Settings.settingsList
    }

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

    var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()

    let indicatorView = NVActivityIndicatorView(frame: CGRect(), type: .ballPulse, color: .white, padding: 0)

    // flag for login
    var loadMemoryFromNetwork: Bool? {
        didSet {
            getMessagesFromMemory()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTitle()
        setupView()
        setupCollectionView()
        setupInputComponents()

        // Dismiss keyboard when touched anywhere in CV
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignResponders)))

        // Configure Location Manager
        configureLocationManager()

        initSnowboy()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscriveToKeyboardNotifications()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadMessages()

        if UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.hotwordEnabled) {
            startHotwordRecognition()
        } else if let timer = hotwordTimer {
            timer.invalidate()
        }

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopRecording()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("memory issue")
    }

    // Number of items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // print("Number of messages: \(messages.count)")
        return messages.count
    }

    // Configure Cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let message = messages[indexPath.row]

        if message.actionType == ActionType.indicatorView.rawValue {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControllerConstants.indicatorCell, for: indexPath) as? ActivityIndicatorCell {
                return cell
            }
        } else {
            let messageBody = message.message
            let estimatedFrame = self.estimatedFrame(messageBody: messageBody)

            if message.fromUser {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControllerConstants.outgoingCell, for: indexPath) as? OutgoingChatCell {
                    cell.message = message
                    cell.setupCell(estimatedFrame, view.frame)
                    return cell
                }
            } else if message.actionType == ActionType.rss.rawValue || message.actionType == ActionType.websearch.rawValue {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControllerConstants.rssCell, for: indexPath) as? RSSCell {
                    cell.message = message
                    return cell
                }
            }

            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControllerConstants.incomingCell, for: indexPath) as? IncomingBubbleCell {
                cell.message = message
                cell.setupCell(estimatedFrame, view.frame)
                return cell
            }
        }
        return UICollectionViewCell()
    }

    // Calculate Bubble Height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = messages[indexPath.row]

        if message.actionType == ActionType.indicatorView.rawValue {
            return CGSize(width: view.frame.width, height: 44)
        } else {
            let estimatedFrame = self.estimatedFrame(messageBody: message.message)
            if message.message.isImage() {
                return CGSize(width: view.frame.width, height: 160)
            } else if message.actionType == ActionType.map.rawValue {
                return CGSize(width: view.frame.width, height: 240)
            } else if message.actionType == ActionType.rss.rawValue ||
                message.actionType == ActionType.websearch.rawValue {
                return CGSize(width: view.frame.width, height: 140)
            }
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 38)
        }
    }

    // Set Edge Insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }

    lazy var scrollButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "scroll_arrow"), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(scrollToLast), for: .touchUpInside)
        button.cornerRadius = 20
        return button
    }()

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row != messages.count - 1 {
            scrollButton.isHidden = false
        } else {
            scrollButton.isHidden = true
        }
    }

    // Setup Input Text View
    lazy var inputTextView: RSKGrowingTextView = {
        let textView = RSKGrowingTextView()
        textView.placeholder = ControllerConstants.askSusi as NSString
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.backgroundColor = .white
        textView.maximumNumberOfLines = 2
        textView.layer.cornerRadius = 15
        textView.delegate = self
        textView.accessibilityIdentifier = ControllerConstants.TestKeys.chatInputView
        return textView
    }()

    // Setup Send Button
    lazy var sendButton: FABButton = {
        let button = FABButton()
        button.setImage(UIImage(named: ControllerConstants.mic), for: .normal)
        button.addTarget(self, action: #selector(setTargetForSendButton), for: .touchUpInside)
        button.backgroundColor = UIColor.defaultColor()
        button.accessibilityIdentifier = ControllerConstants.TestKeys.send
        return button
    }()

    // Snowboy
    let RESOURCE = Bundle.main.path(forResource: "common", ofType: "res")
    let MODEL = Bundle.main.path(forResource: "susi", ofType: "pmdl")

    var wrapper: SnowboyWrapper! = nil

    var audioRecorder: AVAudioRecorder!
    var soundFileURL: URL!

    var hotwordTimer: Timer!

    var detectionTimer: Timer?
    var isSpeechRecognitionRunning: Bool = false
    let audioSession = AVAudioSession.sharedInstance()
    let speechSynthesizer = AVSpeechSynthesizer()
}
