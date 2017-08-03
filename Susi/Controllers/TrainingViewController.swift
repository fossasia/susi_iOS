//
//  TrainingViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-03.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material
import AVFoundation

class TrainingViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    var audioRecorder: AVAudioRecorder!
    var count = 0

    // Get directory
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        addCancelNavItem()
        setupUI()
    }

    func setupNavBar() {
        guard let navBar = navigationController?.navigationBar as? NavigationBar else {
            return
        }

        let activeTheme = UserDefaults.standard.string(forKey: ControllerConstants.UserDefaultsKeys.theme)
        if activeTheme == theme.light.rawValue {
            navBar.backgroundColor = UIColor.hexStringToUIColor(hex: "#4184F3")
            UIApplication.shared.statusBarView?.backgroundColor = UIColor.hexStringToUIColor(hex: "#4184F3")
        } else if activeTheme == theme.dark.rawValue {
            navBar.backgroundColor = UIColor.defaultColor()
            UIApplication.shared.statusBarView?.backgroundColor = UIColor.defaultColor()
        }
    }

    func addCancelNavItem() {
        navigationItem.title = ControllerConstants.Settings.trainHotword
        navigationItem.titleLabel.textColor = .white

        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped(_:)))
        cancelButton.tintColor = .white
        navigationItem.rightBarButtonItems = [cancelButton]
    }

    func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func setupUI() {
        stopRecordButton.isEnabled = false
    }

    @IBAction func startRecording(_ sender: Any) {
        recordingActive(state: true)

        // Set name of file
        // Get complete path
        let recordingName = "recordedVoice\(count).wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath)

        // Get instance
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])

        // Start Recording
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(_ sender: Any) {
        recordingActive(state: false)

        // Stop Recording
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        count += 1

        if count == 3 {
            recordingActive(state: false)
            recordingLabel.text = "Recording complete. Training..."
            recordButton.isEnabled = false

            let params: NSMutableDictionary = [
                "name": "susi",
                "token":"cb01d0e0df6b7abd22992ff897e50965653a7b67",
                "microphone":"iphone microphone",
                "language":"en"
            ]

            let dict = [
                [
                    "wave":getRecordedDataAsBase64String(fileUniqueIdentifier: 0)
                ],
                [
                    "wave":getRecordedDataAsBase64String(fileUniqueIdentifier: 1)
                ],
                [
                    "wave":getRecordedDataAsBase64String(fileUniqueIdentifier: 2)
                ]
            ]
            params.setValue(dict, forKey: "voice_samples")

            Client.sharedInstance.trainHotwordUsingSnowboy(params as! [String : AnyObject], { (file, success, _) in
                DispatchQueue.main.async {
                    print(file, success)
                }
            })

        }

    }

    func recordingActive(state: Bool) {
        recordButton.isEnabled = !state
        stopRecordButton.isEnabled = state
        recordingLabel.text = state == true ? "Recording" : "Tap to start recording"
    }

    func getRecordedDataAsBase64String(fileUniqueIdentifier: Int) -> String {
        do {
            let recordingName = "recordedVoice\(fileUniqueIdentifier).wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURL(withPathComponents: pathArray)

            let fileData = try Data.init(contentsOf: filePath!)
            let fileStream = fileData.base64EncodedString(options: .endLineWithLineFeed)
            return fileStream
        } catch let error {
            debugPrint(error.localizedDescription)
            return ""
        }
    }

}
