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

class ChatViewController: UICollectionViewController {

    var messages = List<Message>()
    let realm = try! Realm()

    // Settings Button Configure
    lazy var settingsButton: IconButton = {
        let image = UIImage(named: "Settings")?.withRenderingMode(.alwaysTemplate)
        let ib = IconButton()
        ib.image = image
        ib.cornerRadius = 18.0
        ib.addTarget(self, action: #selector(presentSettingsController), for: .touchUpInside)
        ib.tintColor = .black
        return ib
    }()

    // Location Manager
    var locationManager = CLLocationManager()
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
        setupTheme()

        // Dismiss keyboard when touched anywhere in CV
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignResponders)))

        // Configure Location Manager
        configureLocationManager()
        loadMessages()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()

        // Hotword recognition stuff
        checkAndAssignIfModelExists()
        initSnowboy()

        if UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.hotwordEnabled) {
            startHotwordRecognition()
        } else if let timer = hotwordTimer {
            timer.invalidate()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscriveToKeyboardNotifications()
        stopRecording()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupWallpaper()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("memory issue")
    }

    lazy var scrollButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "scroll_arrow"), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(scrollToLast), for: .touchUpInside)
        button.cornerRadius = 20
        return button
    }()

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
        button.accessibilityIdentifier = ControllerConstants.TestKeys.send
        return button
    }()

    // Snowboy
    let RESOURCE = Bundle.main.path(forResource: "common", ofType: "res")
    var MODEL: String = ""

    var wrapper: SnowboyWrapper! = nil

    var audioRecorder: AVAudioRecorder!
    var soundFileURL: URL!

    var hotwordTimer: Timer!

    var detectionTimer: Timer?
    var isSpeechRecognitionRunning: Bool = false
    let audioSession = AVAudioSession.sharedInstance()
    let speechSynthesizer = AVSpeechSynthesizer()
}
