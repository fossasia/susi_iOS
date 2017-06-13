//
//  MainVCDelegates.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Popover
import AVFoundation
import CoreLocation

extension MainViewController: CLLocationManagerDelegate {

    // Configures Location Manager
    func configureLocationManager() {
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined || CLLocationManager.authorizationStatus() == .denied {
            self.locationManager.requestWhenInUseAuthorization()
        }

        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

}

extension MainViewController: UIImagePickerControllerDelegate {

    // Show image picker to set/reset wallpaper
    func showImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            // Show error dialog if no photo is available in photo album
            let errorDialog = UIAlertController(title: ControllerConstants.errorDialogTitle, message: ControllerConstants.errorDialogMessage, preferredStyle: UIAlertControllerStyle.alert)
            errorDialog.addAction(UIAlertAction(title: ControllerConstants.dialogCancelAction, style: .cancel, handler: { (_: UIAlertAction!) in
                errorDialog.dismiss(animated: true, completion: nil)
            }))
            self.present(errorDialog, animated: true, completion: nil)
        }

    }

    // Set chat background image
    func setBackgroundImage(image: UIImage!) {
        let bgView = UIImageView()
        bgView.contentMode = .scaleAspectFill
        bgView.image = image
        self.collectionView?.backgroundView = bgView
    }

    // Clear chat background image
    func clearBackgroundImage() {
        self.collectionView?.backgroundView = nil
    }

    // Save image selected by user to user defaults
    func saveWallpaperInUserDefaults(image: UIImage!) {
        let imageData = UIImageJPEGRepresentation(image!, 1.0)
        let defaults = UserDefaults.standard
        defaults.set(imageData, forKey: ControllerConstants.UserDefaultsKeys.wallpaper)
    }

    // Check if user defaults have an image data saved else return nil/Any
    func getWallpaperFromUserDefaults() -> Any? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: ControllerConstants.UserDefaultsKeys.wallpaper)
    }

    // Remove wallpaper from user defaults
    func removeWallpaperFromUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: ControllerConstants.UserDefaultsKeys.wallpaper)
        clearBackgroundImage()
    }

    // Callback when image is selected from gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let image = chosenImage {
            setBackgroundImage(image: image)
            saveWallpaperInUserDefaults(image: image)
        }
    }

    // Callback if cancel selected from picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // Show wallpaper options to set wallpaper or clear wallpaper
    func showWallpaperOptions() {
        let imageDialog = UIAlertController(title: ControllerConstants.wallpaperOptionsTitle, message: nil, preferredStyle: UIAlertControllerStyle.alert)

        imageDialog.addAction(UIAlertAction(title: ControllerConstants.wallpaperOptionsPickAction, style: .default, handler: { (_: UIAlertAction!) in
            imageDialog.dismiss(animated: true, completion: nil)
            self.showImagePicker()
        }))

        imageDialog.addAction(UIAlertAction(title: ControllerConstants.wallpaperOptionsNoWallpaperAction, style: .default, handler: { (_: UIAlertAction!) in
            imageDialog.dismiss(animated: true, completion: nil)
            self.removeWallpaperFromUserDefaults()
        }))

        imageDialog.addAction(UIAlertAction(title: ControllerConstants.dialogCancelAction, style: .cancel, handler: { (_: UIAlertAction!) in
            imageDialog.dismiss(animated: true, completion: nil)
        }))

        self.present(imageDialog, animated: true, completion: nil)
    }

}

extension MainViewController: UITableViewDelegate {

    // Enum for menu options in main chat screen
    enum MenuOptions: Int {
        case setttings = 0
        case wallpaper = 1
        case share = 2
        case logout = 3
    }

    // Handles item click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.popover.dismiss()

        let index = indexPath.row
        switch index {
        case MenuOptions.setttings.rawValue:
            let settingsController = SettingsViewController(collectionViewLayout: UICollectionViewFlowLayout())
            self.navigationController?.pushViewController(settingsController, animated: true)
            break
        case MenuOptions.wallpaper.rawValue:
            showWallpaperOptions()
            break
        case MenuOptions.logout.rawValue:
            logoutUser()
            break
        default:
            break
        }
    }

    func logoutUser() {
        Client.sharedInstance.logoutUser { (success, error) in
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    debugPrint(error)
                }
            }
        }
    }

}

extension MainViewController: UITableViewDataSource {

    // Number of options in popover
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ControllerConstants.Settings.settingsList.count
    }

    // Configure setting cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)

        let item = ControllerConstants.Settings.settingsList[indexPath.row]
        cell.textLabel?.text = item
        cell.imageView?.image = UIImage(named: item.lowercased())
        return cell
    }

}

extension MainViewController: AVAudioPlayerDelegate {

    func initSnowboy() {
        wrapper = SnowboyWrapper(resources: RESOURCE, modelStr: MODEL)
        wrapper.setSensitivity("0.5")
        wrapper.setAudioGain(1.0)
        //  print("Sample rate: \(wrapper?.sampleRate()); channels: \(wrapper?.numChannels()); bits: \(wrapper?.bitsPerSample())")
    }

    func startHotwordRecognition() {
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(startRecording), userInfo: nil, repeats: true)
        timer.fire()
    }

    func runSnowboy() {

        let file = try! AVAudioFile(forReading: soundFileURL)
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 16000.0, channels: 1, interleaved: false)
        let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(file.length))
        try! file.read(into: buffer)
        let array = Array(UnsafeBufferPointer(start: buffer.floatChannelData![0], count:Int(buffer.frameLength)))

        // print("Frame capacity: \(AVAudioFrameCount(file.length))")
        // print("Buffer frame length: \(buffer.frameLength)")

        _ = wrapper.runDetection(array, length: Int32(buffer.frameLength))
        // print("Result: \(result)")
    }

    func playAudio() {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf:(soundFileURL))
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch let error {
            print("Audio player error: \(error.localizedDescription)")
        }
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        // print("Audio Recorder did finish recording.")
        runSnowboy()
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Recorder encode error.")
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio player did finish playing.")
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio player decode error.")
    }

}

extension MainViewController: AVAudioRecorderDelegate {

    func startRecording() {
        do {
            let fileMgr = FileManager.default
            let dirPaths = fileMgr.urls(for: .documentDirectory,
                                        in: .userDomainMask)
            soundFileURL = dirPaths[0].appendingPathComponent("temp.wav")
            let recordSettings =
                [AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
                 AVEncoderBitRateKey: 128000,
                 AVNumberOfChannelsKey: 1,
                 AVSampleRateKey: 16000.0] as [String : Any]
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioRecorder = AVAudioRecorder(url: soundFileURL,
                                                settings: recordSettings as [String : AnyObject])
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
            audioRecorder.record(forDuration: 2.0)

            // print("Started recording...")
        } catch let error {
            print("Audio session error: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        if (audioRecorder != nil && audioRecorder.isRecording) {
            audioRecorder.stop()
        }
    }
    
}
