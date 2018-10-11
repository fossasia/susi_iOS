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
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
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

    @objc func downloadModel() {
        let params: NSMutableDictionary = [
            Client.HotwordKeys.name: Client.HotwordValues.susi,
            Client.HotwordKeys.token: Client.HotwordValues.token,
            Client.HotwordKeys.microphone: Client.HotwordValues.microphone,
            Client.HotwordKeys.language: Client.HotwordValues.language
        ]

        let dict = [
            [
                Client.HotwordKeys.wave: getRecordedDataAsBase64String(fileIdentifier: 0)
            ],
            [
                Client.HotwordKeys.wave: getRecordedDataAsBase64String(fileIdentifier: 1)
            ],
            [
                Client.HotwordKeys.wave: getRecordedDataAsBase64String(fileIdentifier: 2)
            ]
        ]
        params.setValue(dict, forKey: Client.HotwordKeys.voiceSamples)

        if let params = params as? [String: AnyObject] {
            downloadActive(state: true)
            Client.sharedInstance.trainHotwordUsingSnowboy(params) { (success, _) in
                DispatchQueue.main.async {
                    if success {
                        self.view.makeToast(ControllerConstants.trainingSuccessful.localized())
                        self.downloadActive(state: false)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.view.makeToast(ControllerConstants.downloadFailed.localized())
                        self.downloadActive(state: false, failed: true)
                    }
                }
            }
        }

    }

    func downloadActive(state: Bool, failed: Bool = false) {
        if failed {
            downloadIndicator.stopAnimating()
            downloadLabel.text = ControllerConstants.tapToRetryDownload.localized()
            downloadLabel.addGestureRecognizer(tapGesture)
        } else {
            downloadLabel.text =  ControllerConstants.downloadingTrainedModel.localized()
            downloadLabel.removeGestureRecognizer(tapGesture)
            downloadLabel.isHidden = !state
            downloadIndicator.isHidden = !state
            if state {
                downloadIndicator.startAnimating()
            } else {
                downloadIndicator.stopAnimating()
            }
        }
    }

    func checkIfModelExists() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = dir.appendingPathComponent(ControllerConstants.hotwordFileName)
            if !FileManager.default.fileExists(atPath: filePath.path) {
                downloadActive(state: false, failed: true)
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
