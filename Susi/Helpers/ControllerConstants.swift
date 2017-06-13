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
    static let play = "play"
    static let timeZone = "-530"
    static let askSusi = "Ask Susi Something..."
    static let susiTitle = "    Susi"
    static let cellId = "cellId"
    static let incomingCell = "incomingCell"
    static let outgoingCell = "outgoingCell"
    static let rssCell = "rssCell"
    static let defaultMessage = "Sample message"
    static let defaultWebSearchImage = "no-image"
    static let standardServer = "Standard Server"
    static let customServer = "Custom Server"
    static let customIPAddress = "Address http://"

    struct Login {
        static let susiImage = "susi"
        static let emailAddress = "Email Address"
        static let invalidEmail = "Error, incorrect email"
        static let password = "Password"
        static let passwordLengthError = "Error, Should be at least 8 characters"
        static let login = "LOGIN"
        static let forgotPassword = "Forgot Password?"
        static let signUpForSusi = "Sign up for SUSI"
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

    struct Settings {
        static let settings = "Settings"
        static let headerId = "headerId"
        static let sectionHeaders = ["Chat Settings", "Mic Settings", "Speech Settings"]
        static let enterToSend = "Enter To Send"
        static let sendMessageByReturn = "Send message by hitting return"
        static let micInput = "Mic Input"
        static let speechOutput = "Speech Output"
        static let enableSpeechOutputOnlyInput = "Enable speech output only for input"
        static let speechOutputAlwaysOn = "Speech Output Always On"
        static let enableSpeechOutputOutputRegardlessOfInput = "Enable speech output regardless of input"
        static let language = "Language"
        static let selectLanguage = "Select Language"
        static let rateSusi = "Rate Susi"
        static let rateOnAppStore = "Rate our app on App Store"
        static let settingsList = ["Settings", "Wallpaper", "Share", "Logout"]
    }

    struct UserDefaultsKeys {
        static let user = "user"
        static let enterToSend = "enterToSend"
        static let micInput = "micInput"
        static let speechOutput = "speechOutput"
        static let speechOutputAlwaysOn = "speechOutputAlwaysOn"
        static let wallpaper = "wallpaper"
        static let ipAddress = "ipAddress"
        static let firstLaunch = "firstLaunch"
    }

}
