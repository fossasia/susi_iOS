//
//  ControllerConstants.swift
//  Susi
//
//  Created by ishaan on 31/05/17.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import Foundation

class ControllerConstants {
    static let errorDialogTitle = "Image Pick Error"
    static let errorDialogMessage = "Cannot access photos in your albums"
    static let wallpaperOptionsTitle = "Set Wallpaper"
    static let toggleTheme = "Toggle Theme"
    static let wallpaperOptionsPickAction = "Pick image from gallery"
    static let wallpaperOptionsNoWallpaperAction = "No wallpaper"
    static let dialogCancelAction = "Cancel"
    static let emailSent = "Email Sent"
    static let ok = "Ok"
    static let forgotPassword = "Forgot Password"
    static let reset = "Reset"
    static let enterEmailID = "Enter your Email ID"
    static let invalidEmail = "Invalid Email ID"
    static let errorOccured = "Some error occured"
    static let json = "json"
    static let send = "send"
    static let mic = "microphone"
    static let play = "play"
    static let timeZone = "-530"
    static let askSusi = "Ask Susi Something..."
    static let susiTitle = "    Susi"
    static let cellId = "cellId"
    static let incomingCell = "incomingCell"
    static let outgoingCell = "outgoingCell"
    static let rssCell = "rssCell"
    static let indicatorCell = "indicatorCell"
    static let defaultMessage = ""
    static let defaultWebSearchImage = "no-image"
    static let standardServer = "Standard Server"
    static let customServer = "Custom Server"
    static let customIPAddress = "Address http://"
    static let key = "key"
    static let value = "value"
    static let accepted = "Accepted"
    static let thumbsUp = "thumbs_up"
    static let thumbsDown = "thumbs_down"
    static let hotwordFileName = "susi.pmdl"
    static let settings = "Settings"
    static let trainHotword = "Let's train SUSI"

    struct Login {
        static let susiImage = "susi"
        static let emailAddress = "Email Address"
        static let invalidEmail = "Error, incorrect email"
        static let password = "Password"
        static let passwordLengthError = "Error, Should be at least 8 characters"
        static let login = "LOGIN"
        static let forgotPassword = "Forgot Password?"
        static let signUpForSusi = "Sign up for SUSI"
        static let skip = "Skip"
    }

    struct SignUp {
        static let emailAddress = "Email Address"
        static let invalidEmail = "Error, incorrect email"
        static let password = "Password"
        static let passwordError = "Password should be 6 characters long with one uppercase, lowercase and a number"
        static let confirmPassword = "Confirm Password"
        static let passwordDoNotMatch = "Passwords do not match"
        static let signUp = "SIGN UP"
    }

    struct UserDefaultsKeys {
        static let user = "user"
        static let enterToSend = "enterAsSend"
        static let micInput = "micInput"
        static let speechOutput = "speechOutput"
        static let speechOutputAlwaysOn = "speechOutputAlways"
        static let speechRate = "speechRate"
        static let speechPitch = "speechPitch"
        static let wallpaper = "wallpaper"
        static let ipAddress = "ipAddress"
        static let hotwordEnabled = "hotwordRecognition"
        static let ttsLanguage = "ttsLanguage"
        static let prefLanguage = "prefLanguage"
        static let theme = "theme"
    }

    struct TestKeys {
        static let email = "email"
        static let password = "password"
        static let send = "send"
        static let login = "login"
        static let signUp = "signUp"
        static let returnHit = "return"
        static let incorrectLogin = "Email ID / Password incorrect"
        static let emailDetail = "emailDetail"
        static let confirmPassword = "confirmPassword"
        static let forgotPassword = "forgotPassword"
        static let reset = "reset"
        static let emailSent = "Email Sent"
        static let ok = "Ok"
        static let skip = "Skip"
        static let chatInputView = "inputView"
        static let logout = "Logout"
        static let rssCollectionView = "rssCollectionView"
        static let chatCollectionView = "chatCollectionView"
        static let chatCells = "chatCell"
        static let settings = "Settings"

        struct TestAccount {
            static let emailId = "susi.ai@mail.com"
            static let password = "Password123"
            static let incorrectPassword = "password"
            static let invalidEmail = "susi.ai@mail"
        }

    }

}
