//
//  SpeechRecognitionDelegate.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-06.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Speech

extension TrainingViewController: SFSpeechRecognizerDelegate {

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

    func startSpeechRecognition() {
        configureSpeechRecognizer()
        stopRecognition()

        if recognitionTask != nil {
            recognitionTask?.cancel()
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, _) in

            if result != nil {
                if let transcription = result?.bestTranscription.formattedString.lowercased() {
                    print(transcription)
                    if transcription.contains("susi") ||
                        transcription.contains("susie") ||
                        transcription.contains("sushi") ||
                        transcription.contains("suzi") ||
                        transcription.contains("sushie") ||
                        transcription.contains("sissy") {
                        self.stopRecognition()
                        self.stopRecording(self)
                    }
                }
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
    }

    func stopRecognition() {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        recognitionTask?.cancel()
    }

}
