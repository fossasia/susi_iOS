//
//  SpeechRecognizerDelegate.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-07-19.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import Speech
import UIKit

extension ChatViewController: SFSpeechRecognizerDelegate, AVSpeechSynthesizerDelegate {

    func configureSpeechRecognizer() {
        speechRecognizer?.delegate = self

        SFSpeechRecognizer.requestAuthorization { (authStatus) in

            var isEnabled: Bool

            switch authStatus {
            case .authorized:
                print("Autorized speech")
                isEnabled = true

            case .denied:
                print("Denied speech")
                isEnabled = false

            case .restricted:
                print("speech restricted")
                isEnabled = false

            case .notDetermined:
                print("not determined")
                isEnabled = false
            }

            OperationQueue.main.addOperation {
                // enable or disable mic button
                print("Speech status: \(isEnabled)")

            }

        }

    }

    func startSpeechToText() {
        stopHotwordRecognition()
        configureSpeechRecognizer()

        if recognitionTask != nil {
            recognitionTask?.cancel()
            resetSpeechConfig()
        }

        isSpeechRecognitionRunning = true

        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
            try audioSession.setMode(AVAudioSessionModeDefault)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, _) in

            var isFinal = false

            if result != nil {
                self.inputTextField.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }

            func setTimer() {
                self.detectionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (timer) in
                    self.handleSend()
                    isFinal = true
                    timer.invalidate()
                    self.recognitionTask?.cancel()
                })
            }

            if let timer = self.detectionTimer, timer.isValid {
                timer.invalidate()
                setTimer()
            } else if let text = self.inputTextField.text, !text.isEmpty {
                setTimer()
            }

        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()

        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }

        print("Say something, I'm listening!")

        let indicatorFrame = CGRect(x: 0.0, y: 0.0, width: 16, height: 16)
        indicatorView.frame = indicatorFrame
        indicatorView.center = sendButton.center

        // Listening indicator swift
        indicatorView.isUserInteractionEnabled = true
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(setTargetForSendButton))
        gesture.numberOfTapsRequired = 1
        indicatorView.addGestureRecognizer(gesture)

        sendButton.setImage(nil, for: .normal)
        indicatorView.startAnimating()
        sendButton.addSubview(indicatorView)
        sendButton.addConstraintsWithFormat(format: "V:|[v0(14)]|", views: indicatorView)
        sendButton.addConstraintsWithFormat(format: "H:|[v0(14)]|", views: indicatorView)

        inputTextField.isUserInteractionEnabled = false
        indicatorView.stopAnimating()
    }

    func setTargetForIndicatorView() {
        if isSpeechRecognitionRunning {
            startSpeechToText()
        } else {
            stopSpeechToText()
            checkAndRunHotwordRecognition()
        }
    }

    func resetSpeechConfig() {
        audioEngine.inputNode?.removeTap(onBus: 0)
        audioEngine.stop()
    }

    func stopSpeechToText() {
        print("audioEngine stopped")
        resetSpeechConfig()

        indicatorView.removeFromSuperview()
        recognitionTask?.cancel()
        detectionTimer?.invalidate()

        isSpeechRecognitionRunning = false
        inputTextField.isUserInteractionEnabled = true
        sendButton.tag = 0
        setImageForSendButton()
        checkAndRunHotwordRecognition()
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("utterance complete")
        stopSpeechToText()
    }

    func speakAction(_ string: String, language: String?) {
        if isSpeechRecognitionRunning &&
            (UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.speechOutput) ||
            UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.speechOutputAlwaysOn)) {
            let speechUtterance = AVSpeechUtterance(string: string)
            speechSynthesizer.delegate = self

            if let language = language {
                speechUtterance.voice = AVSpeechSynthesisVoice(language: language)
            }

            speechUtterance.rate = 0.4

            speechSynthesizer.speak(speechUtterance)
        } else {
            stopSpeechToText()
        }
    }

    func checkAndRunHotwordRecognition() {
        if UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.hotwordEnabled) {
            startHotwordRecognition()
        } else if let timer = hotwordTimer {
            timer.invalidate()
        }
    }

}
