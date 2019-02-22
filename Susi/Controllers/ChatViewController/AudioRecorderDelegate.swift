//
//  AudioRecorderDelegate.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-07-19.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import AVFoundation

extension ChatViewController: AVAudioRecorderDelegate {

    /**
        Used to initialise the snowboy wrapper
    **/
    func initSnowboy() {
        wrapper?.setSensitivity("0.5")
        wrapper?.setAudioGain(1.0)
        //  print("Sample rate: \(wrapper?.sampleRate()); channels: \(wrapper?.numChannels()); bits: \(wrapper?.bitsPerSample())")
    }

    /**
        Starts a 2 seconds timer 
        calling the startRecording method
    **/
    func startHotwordRecognition() {
        hotwordTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(startRecording), userInfo: nil, repeats: true)
        hotwordTimer.fire()
    }

    /**
        Reads the recorded sound
        and runs detection to check if the
        buffer contains the hotword
        and starts speech to text if it does
    **/
    func runSnowboy() {
        let file = try! AVAudioFile(forReading: soundFileURL)
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 16000.0, channels: 1, interleaved: false)

        let audioFrameCount = AVAudioFrameCount(file.length)
        if audioFrameCount > 0 {
            let buffer = AVAudioPCMBuffer(pcmFormat: format!, frameCapacity: audioFrameCount)
            do {
                try file.read(into: buffer!)
            } catch let error {
                print(error.localizedDescription)
            }
            let array = Array(UnsafeBufferPointer(start: buffer?.floatChannelData![0], count: Int(UInt32(buffer!.frameLength))))

            // print("Frame capacity: \(AVAudioFrameCount(file.length))")
            // print("Buffer frame length: \(buffer.frameLength)")

            let result = wrapper?.runDetection(array, length: Int32(buffer!.frameLength))
            // print("Result: \(result)")

            if result == 1 {
                print("Hotword detected")
                startSpeechToText()
            }
        }
    }

    /**
        Detection runs only after recording is complete
    **/
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        // print("Audio Recorder did finish recording.")
        runSnowboy()
    }

    /**
        Configures settings for the recorder
        and records for 1.5 seconds
    **/
    @objc func startRecording() {
        do {
            let fileMgr = FileManager.default
            let dirPaths = fileMgr.urls(for: .documentDirectory,
                                        in: .userDomainMask)
            soundFileURL = dirPaths[0].appendingPathComponent("temp.wav")
            let recordSettings =
                [AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
                 AVEncoderBitRateKey: 128000,
                 AVNumberOfChannelsKey: 1,
                 AVSampleRateKey: 16000.0] as [String: Any]
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.spokenAudio)
            try audioRecorder = AVAudioRecorder(url: soundFileURL,
                                                settings: recordSettings as [String: AnyObject])
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
            audioRecorder.record(forDuration: 1.5)

            //print("Started recording...")
        } catch let error {
            print("Audio session error: \(error.localizedDescription)")
        }
    }

    /**
        Stops the audio recorder and the hotword timer
    **/
    func stopHotwordRecognition() {
        if audioRecorder != nil {
            audioRecorder.stop()
        }
        if hotwordTimer != nil {
            hotwordTimer.invalidate()
        }
    }

}
