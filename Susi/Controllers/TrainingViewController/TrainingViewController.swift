//
//  TrainingViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-03.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import Material

class TrainingViewController: UIViewController {

    var audioRecorder: AVAudioRecorder!

    // Get directory
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

    let audioSession = AVAudioSession.sharedInstance()
    var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    var isRecording = false

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(downloadModel))

    // MARK: - Outlets
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var indicator1: UIActivityIndicatorView!
    @IBOutlet weak var indicator2: UIActivityIndicatorView!
    @IBOutlet weak var indicator3: UIActivityIndicatorView!

    @IBOutlet weak var recordingLabel1: UILabel!
    @IBOutlet weak var recordingLabel2: UILabel!
    @IBOutlet weak var recordingLabel3: UILabel!

    @IBOutlet weak var recordPhI1: UIImageView!
    @IBOutlet weak var recordPhI2: UIImageView!
    @IBOutlet weak var recordPhI3: UIImageView!

    @IBOutlet weak var finishLaterButton: FlatButton!

    @IBOutlet weak var downloadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var downloadLabel: UILabel!

    var count: Int = 0 {
        didSet {
            if count == 1 {
                indicator1.stopAnimating()
                recordPhI1.isHidden = false
                recordPhI1.image = UIImage(named: "check")
                recordPhI1.tintColor = .green
                recordingLabel1.text = "Complete"
                recordingLabel1.isHidden = false
            } else if count == 2 {
                indicator2.stopAnimating()
                recordPhI2.isHidden = false
                recordPhI2.image = UIImage(named: "check")
                recordPhI2.tintColor = .green
                recordingLabel2.text = "Complete"
                recordingLabel2.isHidden = false
            } else if count == 3 {
                indicator3.stopAnimating()
                recordPhI3.isHidden = false
                recordPhI3.image = UIImage(named: "check")
                recordPhI3.tintColor = .green
                recordingLabel3.text = "Complete"
                recordingLabel3.isHidden = false
                micButton.isEnabled = false
                finishLaterButton.setTitle("Download Complete", for: .normal)
                finishLaterButton.isEnabled = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        addCancelNavItem()
        addTargets()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkRecordings()
    }

}
