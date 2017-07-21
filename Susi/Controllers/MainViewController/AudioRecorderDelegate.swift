//
//  AudioRecorderDelegate.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-07-19.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import AudioKit

extension ChatViewController: EZMicrophoneDelegate {

    func initPermissions() {
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: nil)
    }

    func initSnowboy() {
        wrapper = SnowboyWrapper(resources: RESOURCE, modelStr: MODEL)
        wrapper.setSensitivity("0.5")
        wrapper.setAudioGain(2.0)
//        print("Sample rate: \(wrapper?.sampleRate()); channels: \(wrapper?.numChannels()); bits: \(wrapper?.bitsPerSample())")
    }

    func initMic() {
        var audioStreamBasicDescription: AudioStreamBasicDescription = EZAudioUtilities.monoFloatFormat(withSampleRate: 44100.0)
        audioStreamBasicDescription.mFormatID = kAudioFormatLinearPCM
        audioStreamBasicDescription.mSampleRate = 44100.0
        audioStreamBasicDescription.mFramesPerPacket = 1
        audioStreamBasicDescription.mBytesPerPacket = 2
        audioStreamBasicDescription.mBytesPerFrame = 2
        audioStreamBasicDescription.mChannelsPerFrame = 1
        audioStreamBasicDescription.mBitsPerChannel = 16
        audioStreamBasicDescription.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked
        audioStreamBasicDescription.mReserved = 0

        self.microphone = EZMicrophone.init(delegate: self, with: audioStreamBasicDescription)
        let inputs: [Any] = EZAudioDevice.inputDevices()
        microphone.device = inputs.last as! EZAudioDevice
    }

    func microphone(_ microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>?>!, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        DispatchQueue.main.async(execute: {() -> Void in

            let array = Array(UnsafeBufferPointer(start: buffer.pointee, count:Int(bufferSize)))

            let result: Int =  Int(self.wrapper.runDetection(array, length: Int32(bufferSize)))
            if result == 1 {
                print("Hotword Detected")
            }
            print(result)
        })
    }

    func startHotwordRecognition() {
        microphone.startFetchingAudio()
    }

    func stopHotwordRecognition() {
        if microphone != nil {
            microphone.stopFetchingAudio()
        }
    }

}
