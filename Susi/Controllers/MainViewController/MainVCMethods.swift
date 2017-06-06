//
//  MainVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import CoreLocation
import Popover
import RSKGrowingTextView

extension MainViewController {

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func handleKeyboardNotification(notification: NSNotification) {

        if let userInfo = notification.userInfo {

            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow

            bottomConstraintTextView?.constant = isKeyboardShowing ? (-keyboardFrame!.height - 8.0) : 0
            bottomConstraintSendButton?.constant = isKeyboardShowing ? (-keyboardFrame!.height - 8.0) : 0

            collectionView?.frame = isKeyboardShowing ? CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - keyboardFrame!.height - 47) :
                CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 47)

            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {

                self.view.layoutIfNeeded()

            }, completion: { (_) in

                if isKeyboardShowing {
                    self.scrollToLast()
                }

            })
        }
    }

    // Resign responders
    func resignResponders() {
        self.view.endEditing(true)
    }

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

    // Setup Navigation Bar
    func setupTitle() {
        navigationItem.title = ControllerConstants.susiTitle
        navigationItem.titleLabel.textAlignment = .left
        navigationItem.titleLabel.textColor = .white

        navigationItem.rightViews = [searchButton, settingsButton]
    }

    // Setup View
    func setupView() {
        self.view.backgroundColor = UIColor.rgb(red: 236, green: 229, blue: 221)
    }

    // Setup Settings View
    func showSettingsView() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width / 2), height: (ControllerConstants.Settings.settingsList.count * 44)))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        self.popover = Popover(options: self.popoverOptions)
        self.popover.show(tableView, fromView: settingsButton)
    }

    // Shows Youtube Player
    func addYotubePlayer(_ videoID: String, _ imageURL: String) {

        // Add image message
        let message = Message(imageURL, true)
        messages.append(message)
        let indexPath = IndexPath(item: messages.count - 1, section: 0)
        collectionView?.insertItems(at: [indexPath])
        self.scrollToLast()

        if let window = UIApplication.shared.keyWindow {
            blackView.frame = window.frame
            self.view.addSubview(blackView)
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))

            self.blackView.addSubview(self.youtubePlayer)
            let centerX = UIScreen.main.bounds.size.width / 2
            let centerY = UIScreen.main.bounds.size.height / 3
            self.youtubePlayer.center = CGPoint(x: centerX, y: centerY)
            self.youtubePlayer.loadVideoID(videoID)

            blackView.alpha = 0
            youtubePlayer.alpha = 0

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.youtubePlayer.alpha = 1
            }, completion: nil)
        }
    }

    func handleDismiss() {

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.removeFromSuperview()
        }, completion: nil)

    }

    // Setup Collection View
    func setupCollectionView() {
        // Check if user defaults have an image, set background as image
        if let userDefaultData = getWallpaperFromUserDefaults() {
            if let imageData = userDefaultData as? Data { // Check if object saved in user defaults if of type Data
                setBackgroundImage(image: UIImage(data : imageData))
            }
        }
        collectionView?.backgroundColor = .clear
        collectionView?.delegate = self
        collectionView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 47)
        collectionView?.register(IncomingBubbleCell.self, forCellWithReuseIdentifier: ControllerConstants.incomingCell)
        collectionView?.register(OutgoingChatCell.self, forCellWithReuseIdentifier: ControllerConstants.outgoingCell)
    }

    // Send Button Action
    func handleSend() {
        if let text = inputTextView.text, text.characters.count > 0 {
            if text.contains(ControllerConstants.play.lowercased()) || text.contains(ControllerConstants.play) {
                let query = text.replacingOccurrences(of: ControllerConstants.play, with: "")
                    .replacingOccurrences(of: ControllerConstants.play.uppercased(), with: "")

                Client.sharedInstance.searchYotubeVideos(query) { (videoID, imageURL, success, error) in
                    DispatchQueue.main.async {
                        if success {
                            self.addYotubePlayer(videoID!, imageURL!)
                        } else {
                            debugPrint(error ?? ControllerConstants.errorOccured)
                        }
                    }
                }

            } else {

                var params: [String : AnyObject] = [
                    Client.WebsearchKeys.Query: inputTextView.text! as AnyObject,
                    Client.ChatKeys.TimeZoneOffset: ControllerConstants.timeZone as AnyObject,
                    Client.ChatKeys.Language: Locale.current.languageCode as AnyObject
                ]

                if let location = locationManager.location {
                    params[Client.ChatKeys.Latitude] = location.coordinate.latitude as AnyObject
                    params[Client.ChatKeys.Longitude] = location.coordinate.longitude as AnyObject
                }

                Client.sharedInstance.queryResponse(params) { (results, success, _) in
                    DispatchQueue.main.async {
                        if success {
                            self.messages.append(results!)
                            let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                            self.collectionView?.insertItems(at: [indexPath])
                        }
                        self.scrollToLast()
                    }
                }
            }
        }
        saveMessage()
    }

    // Setup Input Components
    func setupInputComponents() {

        view.addSubview(inputTextView)
        view.addSubview(sendButton)

        view.layout(sendButton).bottomRight(bottom: 8.0, right: 8.0).width(44).height(44)
        view.layout(inputTextView).bottomLeft(bottom: 8.0, left: 8.0).width(view.frame.width - 64)

        bottomConstraintTextView = NSLayoutConstraint(item: inputTextView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraintTextView!)

        bottomConstraintSendButton = NSLayoutConstraint(item: sendButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraintSendButton!)
    }

    // Temporarily save message to object
    func saveMessage() {
        let message = Message(inputTextView.text!.trimmed)
        messages.append(message)
        let indexPath = IndexPath(item: messages.count - 1, section: 0)
        collectionView?.insertItems(at: [indexPath])
        self.scrollToLast()

        inputTextView.text = ""
    }

    // Scroll to last message
    func scrollToLast() {
        if messages.count > 0 {
            let lastItem = self.messages.count - 1
            let indexPath = IndexPath(item: lastItem, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }

    // Check if chat field empty
    func textViewDidChange(textView: RSKGrowingTextView) {
        if let message = inputTextView.text, message.isEmpty {
            sendButton.isUserInteractionEnabled = false
        } else {
            sendButton.isUserInteractionEnabled = true
        }
    }

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
