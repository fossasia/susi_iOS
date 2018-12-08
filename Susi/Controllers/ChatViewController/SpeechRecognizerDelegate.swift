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
                if !isEnabled {
                    self.stopSpeechToText()
                    self.sendButton.setImage(ControllerConstants.Images.send, for: .normal)
                    self.sendButton.tintColor = .white
                    self.sendButton.backgroundColor = UIColor.defaultColor()
                }
                UserDefaults.standard.set(isEnabled, forKey: ControllerConstants.UserDefaultsKeys.speechToTextAvailable)
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
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord,
                                         mode: AVAudioSession.Mode.default,
                                         options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode

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
                    self.stopSpeechToText()
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

        // Listening indicator swift
        indicatorView.isUserInteractionEnabled = true
        inputTextField.isUserInteractionEnabled = false

        sendButton.setImage(nil, for: .normal)
        indicatorView.startAnimating()
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
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
    }

    func stopSpeechToText() {
        print("audioEngine stopped")
        resetSpeechConfig()

        indicatorView.stopAnimating()
        recognitionTask = nil
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

    func speakAction(_ message: Message) {
        if (UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.speechOutput) && isSpeechRecognitionRunning) ||
            UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.speechOutputAlwaysOn) {
            let speechUtterance = AVSpeechUtterance(string: message.message)
            speechSynthesizer.delegate = self

            if let selectedLanguage = UserDefaults.standard.object(forKey: ControllerConstants.UserDefaultsKeys.languageCode) as? String {
                speechUtterance.voice = AVSpeechSynthesisVoice(language: selectedLanguage)
            } else {
                if let language = message.answerData?.language {
                    speechUtterance.voice = AVSpeechSynthesisVoice(language: language)
                }
            }

            speechUtterance.rate = UserDefaults.standard.float(forKey: ControllerConstants.UserDefaultsKeys.speechRate)
            speechUtterance.pitchMultiplier = UserDefaults.standard.float(forKey: ControllerConstants.UserDefaultsKeys.speechPitch)

            speechSynthesizer.speak(speechUtterance)
        } else {
            stopSpeechToText()
        }
    }

    func stopSpeakAction() {
        speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }

    func checkAndRunHotwordRecognition() {
        if UserDefaults.standard.bool(forKey: ControllerConstants.UserDefaultsKeys.hotwordEnabled) {
            startHotwordRecognition()
        } else if let timer = hotwordTimer {
            timer.invalidate()
        }
    }

}
