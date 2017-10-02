//
//  ControllerConstants.swift
//  Susi
//
//  Created by ishaan on 31/05/17.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import Foundation
import UIKit

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
    static let mapCell = "mapCell"
    static let anchorCell = "anchorCell"
    static let defaultMessage = ""
    static let defaultWebSearchImage = "no-image"
    static let standardServer = "Standard Server"
    static let customServer = "Custom Server"
    static let customIPAddress = "Address http://"
    static let key = "key1"
    static let value = "value1"
    static let count = "count"
    static let accepted = "Accepted"
    static let thumbsUp = "thumbs_up"
    static let thumbsDown = "thumbs_down"
    static let hotwordFileName = "susi.pmdl"
    static let settings = "Settings"
    static let skillListing = "SUSI.AI Skills"
    static let trainHotword = "Let's train SUSI"
    static let passwordDoNotMatch = "Passwords do not match."
    static let resetPassword = "Reset Password"
    static let currentPassword = "Current Password"
    static let newPassword = "New Password"
    static let passwordLengthShort = "Passwords length should be atleast 6 characters"
    static let skillDetailControllerIdentifier = "skillDetail"
    static let customServerURL = "Custom Server URL"
    static let tryIt = "Try It"
    static let invalidIP = "Invalid IP Address"
    static let invalidEmailAddress = "Invalid Email Address"
    static let passwordLengthTooShort = "Password length too short"
    static let meetSusi = "Meet SUSI.AI, Your Artificial Intelligence for Personal Assistants, Robots, Help Desks and Chatbots."
    static let trainingSuccessful = "Training successful"
    static let downloadFailed = "Download Failed!"
    static let tapToRetryDownload = "Tap to retry download"
    static let downloadingTrainedModel = "Downloading Trained Model"
    static let complete = "Complete"
    static let trainingComplete = "Training Complete"
    static let susiAdvice = "To help the app respond to you better, you can teach SUSI the sound of your voice."
    static let saySusi = "Just say \"SUSI\" three times"
    static let listentingSusi1 = "Listening... say \"SUSI\""
    static let listentingSusi2 = "Say \"SUSI\" again"
    static let listentingSusi3 = "Say \"SUSI\" one last time"
    static let finishLater = "FINISH LATER"
    
    struct Settings {
        static let enterToSend = "Enter To Send"
        static let enterToSendSubtitle = "Send message by hitting return"
        static let micInput = "Mic input"
        static let micInputSubtitle = "Enable mic to give voice input"
        static let hotwordDirection = "Hotword Detection"
        static let hotwordDirectionSubtitle = "Enable hotword detection to interact with SUSI in handsfree mode"
        static let speechOutput = "Speech Output"
        static let speechOutputSubtitle = "Enable speech output only for speech input"
        static let speechOutputAlways = "Speech Output always ON"
        static let speechOutputAlwaysSubtitle = "Enable speech output regardless of input type"
        static let language = "Language"
        static let languageSubtitle = "Set a language"
        static let speechRate = "Speech Rate"
        static let speechPitch = "Speech Pitch"
        static let retrainVModel = "Retrain Voice Model"
        static let deleteVModel = "Delete Voice Model"
        static let rateSusi = "Rate SUSI"
        static let rateSusiSubtitle = "Rate SUSI on the App Store"
        static let shareSusi = "Share SUSI"
        static let shareSusiSubtitle = "Share the SUSI App with your friends"
        static let resetPass = "Reset Password"
        static let logout = "Logout"
        static let chatSettings = "Chat Settings";
        static let micSettings = "Mic Settings";
        static let speechSettings = "Speech Settings";
        static let susiVoiceModel = "SUSI Voice Model";
        static let miscellaneous = "Miscellaneous";
    }

    struct Login {
        static let susiImage = "susi"
        static let emailAddress = "Email Address"
        static let invalidEmail = "Error, incorrect email"
        static let password = "Password"
        static let passwordLengthError = "Error, Should be at least 8 characters"
        static let login = "Login"
        static let forgotPassword = "Forgot Password?"
        static let signUpForSusi = "Sign Up for SUSI"
        static let skip = "Skip"
    }

    struct SignUp {
        static let emailAddress = "Email Address"
        static let invalidEmail = "Error, incorrect email"
        static let password = "Password"
        static let passwordError = "Password should be 6 characters long with one uppercase, lowercase and a number"
        static let confirmPassword = "Confirm Password"
        static let passwordDoNotMatch = "Passwords do not match"
        static let signUp = "Sign Up"
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
        static let lanuchedBefore = "lanuchedBefore"
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
        static let settings = "settings"
        static let susiSymbol = "susi symbol"

        struct TestAccount {
            static let emailId = "susi.ai@mail.com"
            static let password = "Password123"
            static let incorrectPassword = "password"
            static let invalidEmail = "susi.ai@mail"
        }

    }

    struct Images {
        static let backArrow = UIImage(named: "back_arrow")
        static let check = UIImage(named: "check")
        static let manualRecord = UIImage(named: "manual_record")
        static let microphone = UIImage(named: "microphone")
        static let placeholder = UIImage(named: "placeholder")
        static let record = UIImage(named: "record")
        static let scrollDown = UIImage(named: "scroll_down")
        static let send = UIImage(named: "send")
        static let settings = UIImage(named: "settings")
        static let susiLogo = UIImage(named: "susi")
        static let thumbsUp = UIImage(named: "thumbs_up")
        static let thumbsDown = UIImage(named: "thumbs_down")
        static let susiSymbol = UIImage(named: "susi_symbol")
    }

}
