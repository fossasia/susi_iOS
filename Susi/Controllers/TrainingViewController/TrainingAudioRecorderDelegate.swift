//
//  TrainingAudioRecorderDelegate.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import AVFoundation

extension TrainingViewController: AVAudioRecorderDelegate {

    @IBAction func startRecording(_ sender: Any) {
        recordingActive(state: true)

        // Set name of file
        // Get complete path
        let recordingName = "recordedVoice\(count).wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        //        print(filePath)

        // Get instance
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setMode(AVAudioSessionModeDefault)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])

        // Start Recording
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        startSpeechRecognition()
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
            downloadModel()
        }

    }

    func downloadModel() {
        let params: NSMutableDictionary = [
            "name": "susi",
            "token": "1b286c615e95d848814144e6ffe0551505fe979c",
            "microphone": "iphone microphone",
            "language": "en"
        ]

        let dict = [
            [
                "wave": getRecordedDataAsBase64String(fileIdentifier: 0)
            ],
            [
                "wave": getRecordedDataAsBase64String(fileIdentifier: 1)
            ],
            [
                "wave": getRecordedDataAsBase64String(fileIdentifier: 2)
            ]
        ]
        params.setValue(dict, forKey: "voice_samples")

        if let params = params as? [String : AnyObject] {
            downloadActive(state: true)
            Client.sharedInstance.trainHotwordUsingSnowboy(params) { (success, _) in
                DispatchQueue.main.async {
                    if success {
                        self.view.makeToast("Training successful")
                        self.downloadActive(state: false)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.view.makeToast("Download Failed!")
                        self.downloadActive(state: false, failed: true)
                    }
                }
            }
        }

    }

    func downloadActive(state: Bool, failed: Bool = false) {
        if failed {
            downloadIndicator.stopAnimating()
            downloadLabel.text = "Tap to retry download"
            downloadLabel.addGestureRecognizer(tapGesture)
        } else {
            downloadLabel.text = "Downloading Trained Model"
            downloadLabel.removeGestureRecognizer(tapGesture)
            if state {
                downloadLabel.isHidden = !state
                downloadIndicator.isHidden = !state
                downloadIndicator.startAnimating()
            } else {
                downloadLabel.isHidden = !state
                downloadIndicator.isHidden = !state
                downloadIndicator.startAnimating()
            }
        }
    }

    func recordingActive(state: Bool) {
        isRecording = state
        updateUI()
    }

    func getRecordedDataAsBase64String(fileIdentifier: Int) -> String {
        do {
            if let filePath = checkIfFileExistsAndReturnPath(fileIdentifier: fileIdentifier) {
                let fileData = try Data.init(contentsOf: filePath)
                let fileStream = fileData.base64EncodedString(options: .endLineWithLineFeed)
                return fileStream
            }
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        return ""
    }

    func updateUI() {
        if isRecording {
            if count == 0 {
                indicator1.startAnimating()
                recordPhI1.isHidden = true
                recordingLabel1.isHidden = false
            } else if count == 1 {
                indicator2.startAnimating()
                recordPhI2.isHidden = true
                recordingLabel2.isHidden = false
            } else if count == 2 {
                indicator3.startAnimating()
                recordPhI3.isHidden = true
                recordingLabel3.isHidden = false
            }
        }
    }

    func checkIfFileExistsAndReturnPath(fileIdentifier: Int) -> URL? {
        let recordingName = "recordedVoice\(fileIdentifier).wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        if let path = filePath?.path {
            if FileManager.default.fileExists(atPath: path) {
                return filePath
            }
        }
        return nil
    }

    func checkRecordings() {
//        do {
//            try FileManager.default.removeItem(at: checkIfFileExistsAndReturnPath(fileIdentifier: 0)!)
//            try FileManager.default.removeItem(at: checkIfFileExistsAndReturnPath(fileIdentifier: 1)!)
//            try FileManager.default.removeItem(at: checkIfFileExistsAndReturnPath(fileIdentifier: 2)!)
//        } catch let error {
//            print(error.localizedDescription)
//        }
        if let _ = checkIfFileExistsAndReturnPath(fileIdentifier: 0) {
            count = 1
        }
        if let _ = checkIfFileExistsAndReturnPath(fileIdentifier: 1) {
            count = 2
        }
        if let _ = checkIfFileExistsAndReturnPath(fileIdentifier: 2) {
            count = 3
        }
    }

}
