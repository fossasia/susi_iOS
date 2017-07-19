//
//  ImagePickerViewDelegate.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-07-19.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

extension ChatViewController: UIImagePickerControllerDelegate {

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
