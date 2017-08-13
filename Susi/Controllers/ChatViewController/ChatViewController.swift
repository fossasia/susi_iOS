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

    // MARK: - Variable Declarations

    // Opens settings view controller
    lazy var settingsButton: IconButton = {
        let image = UIImage(named: "Settings")?.withRenderingMode(.alwaysTemplate)
        let ib = IconButton()
        ib.image = image
        ib.cornerRadius = 18.0
        ib.addTarget(self, action: #selector(presentSettingsController), for: .touchUpInside)
        ib.tintColor = .black
        return ib
    }()

    // youtube player
    lazy var youtubePlayer: YouTubePlayerView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 16, height: self.view.frame.height * 1 / 3)
        let player = YouTubePlayerView(frame: frame)
        return player
    }()

    // scroll down button
    lazy var scrollButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "scroll_arrow"), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(scrollToLast), for: .touchUpInside)
        button.cornerRadius = 20
        return button
    }()

    // chat input field
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

    // send button
    lazy var sendButton: FABButton = {
        let button = FABButton()
        button.setImage(UIImage(named: ControllerConstants.mic), for: .normal)
        button.addTarget(self, action: #selector(setTargetForSendButton), for: .touchUpInside)
        button.accessibilityIdentifier = ControllerConstants.TestKeys.send
        return button
    }()

    // contains all the message
    var messages = List<Message>()

    // realm instance
    let realm = try! Realm()

    // used to send user's location to the server
    var locationManager = CLLocationManager()

    // used as an overlay to dismiss the youtube player
    let blackView = UIView()

    // snowboy resource
    let RESOURCE = Bundle.main.path(forResource: "common", ofType: "res")

    // snowboy model
    var MODEL: String = ""

    // snowboy wrapper
    var wrapper: SnowboyWrapper! = nil

    // records audio
    var audioRecorder: AVAudioRecorder!

    // saves the recorded sound
    var soundFileURL: URL!

    // used to start and stop the hotword recognition timer
    var hotwordTimer: Timer!

    // used to stop STT when no input for a few seconds
    var detectionTimer: Timer?

    // flag to check if STT running
    var isSpeechRecognitionRunning: Bool = false

    let audioSession = AVAudioSession.sharedInstance()
    let speechSynthesizer = AVSpeechSynthesizer()

    // constraints for the input field and send button
    var bottomConstraintTextView: NSLayoutConstraint?
    var bottomConstraintSendButton: NSLayoutConstraint?

    // used for speech to text
    var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()

    // indicator view to show STT running (used inside send button)
    let indicatorView = NVActivityIndicatorView(frame: CGRect(), type: .ballPulse, color: .white, padding: 0)

    // flag to load messages from user's account memory
    var loadMemoryFromNetwork: Bool? {
        didSet {
            getMessagesFromMemory()
        }
    }

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupView()
        setupCollectionView()
        setupInputComponents()
        addGestures()
        configureLocationManager()
        loadMessages()
        addSettingsButton()
        addScrollButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()

        checkAndAssignIfModelExists()
        initSnowboy()
        checkAndRunHotwordRecognition()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscriveToKeyboardNotifications()
        stopRecording()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("memory issue")
        initSnowboy()
    }
}
