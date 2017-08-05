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
            recordingLabel.text = "Recording complete. Training..."
            recordButton.isEnabled = false

            let params: NSMutableDictionary = [
                "name": "susi",
                "token": "1b286c615e95d848814144e6ffe0551505fe979c",
                "microphone": "iphone microphone",
                "language": "en"
            ]

            let dict = [
                [
                    "wave": getRecordedDataAsBase64String(fileUniqueIdentifier: 0)
                ],
                [
                    "wave": getRecordedDataAsBase64String(fileUniqueIdentifier: 1)
                ],
                [
                    "wave": getRecordedDataAsBase64String(fileUniqueIdentifier: 2)
                ]
            ]
            params.setValue(dict, forKey: "voice_samples")

            Client.sharedInstance.trainHotwordUsingSnowboy(params as! [String : AnyObject], { (success, _) in
                DispatchQueue.main.async {
                    if success {
                        self.view.makeToast("Training successful")
                    }
                    self.dismiss(animated: true, completion: nil)
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
