//
//  ChatViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material
import CoreLocation
import AVFoundation
import RealmSwift
import Speech
import NVActivityIndicatorView
import Realm
import Reachability

class ChatViewController: UICollectionViewController {
    // MARK: - Variable Declarations

    let reachability = Reachability()!

    lazy var susiSkillListingButton: IconButton = {
        let ib = IconButton()
        ib.image = ControllerConstants.Images.susiSymbol
        ib.layer.cornerRadius = 18.0
        ib.addTarget(self, action: #selector(presentSkillListingController), for: .touchUpInside)
        ib.backgroundColor = UIColor.defaultColor()
        return ib
    }()

    let alert = UIAlertController(title: "Warning", message: "Please Connect to Internet", preferredStyle: .alert)

    // youtube player
    lazy var youtubePlayer: YouTubePlayerView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 16, height: self.view.frame.height * 1 / 3)
        let player = YouTubePlayerView(frame: frame)
        return player
    }()

    // scroll down button
    lazy var scrollButton: UIButton = {
        let button = UIButton()
        button.setImage(ControllerConstants.Images.scrollDown, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(scrollToLast), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()

    // container view
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    // chat input field
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ControllerConstants.askSusi.localized()
        textField.delegate = self
        textField.accessibilityIdentifier = ControllerConstants.TestKeys.chatInputView
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()

    // indicator view to show STT running (used inside send button)
    let indicatorView = NVActivityIndicatorView(frame: CGRect(), type: .ballPulse, color: UIColor.defaultColor(), padding: 0)

    // send button
    lazy var sendButton: FABButton = {
        let button = FABButton()
        isSpeechToTextAvailable = UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.speechToTextAvailable)
        if let _ = speechRecognizer?.isAvailable, isSpeechToTextAvailable {
            button.setImage(ControllerConstants.Images.microphone, for: .normal)
            button.addTarget(self, action: #selector(setTargetForSendButton), for: .touchUpInside)
            button.accessibilityIdentifier = ControllerConstants.TestKeys.send
            button.tintColor = UIColor.defaultColor()
            button.backgroundColor = .clear
        } else {
            button.setImage(ControllerConstants.Images.send, for: .normal)
            button.addTarget(self, action: #selector(setTargetForSendButton), for: .touchUpInside)
            button.accessibilityIdentifier = ControllerConstants.TestKeys.send
            button.tintColor = .white
            button.backgroundColor = UIColor.defaultColor()
        }
        return button
    }()

    // contains all the message
    var messages = [Message]()

    // realm instance
    let realm = try! Realm()

    // used to send user's location to the server
    var locationManager = CLLocationManager()

    // used as an overlay to dismiss the youtube player
    let blackView = UIView()

    // snowboy resource
    let RESOURCE = Bundle.main.path(forResource: "common", ofType: "res")

    // snowboy model
    var MODEL: String = Bundle.main.path(forResource: "susi", ofType: "pmdl")!

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
    var isSpeechToTextAvailable: Bool = false

    let audioSession = AVAudioSession.sharedInstance()
    let speechSynthesizer = AVSpeechSynthesizer()

    // constraints for the input field and send button
    var bottomConstraint: NSLayoutConstraint?

    // used for speech to text
    var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()

    // flag to load messages from user's account memory
    var loadMemoryFromNetwork: Bool = false {
        didSet {
            getMessagesFromMemory()
        }
    }

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setupView()
        setupSendButton()
        setupCollectionView()
        setupInputComponents()
        addGestures()
        configureLocationManager()
        loadMessages()
        addSkillListingButton()
        addScrollButton()

        reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                self.inputTextField.isEnabled = true
                self.alert.dismiss(animated: true, completion: nil)
            }
        }

        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                self.inputTextField.isEnabled = false
                self.present(self.alert, animated: true, completion: nil)
            }
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        checkAndAssignIfModelExists()
        initSnowboy()
        checkAndRunHotwordRecognition()
    }

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(internetConnection), name: Notification.Name.reachabilityChanged, object: reachability)

        do {
            try reachability.startNotifier()
        } catch {
            print(error)
        }
    }


    override func viewWillLayoutSubviews() {
         setCollectionViewOffset()
    }
    
    
    @objc func internetConnection(notification: NSNotification) {
        guard let reachability = notification.object as? Reachability else { return }
        if reachability.connection != .none {
            print("internet is available")
        } else {
            print("internet is not available")
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopHotwordRecognition()
        stopSpeechToText()
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscriveToKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("memory issue")
        initSnowboy()
    }

}
