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
    static let stopCell = "stopCell"
    static let imageCell = "imageCell"
    static let youtubePlayerCell = "youtubePlayerCell"
    static let stopMessage = "Stopped"
    static let defaultMessage = ""
    static let defaultWebSearchImage = "no-image"
    static let standardServer = "Standard Server"
    static let customServer = "Custom Server"
    static let customIPAddress = "Address http://"
    static let key = "key1"
    static let value = "value1"
    static let count = "count"
    static let accepted = "accepted"
    static let thumbsUp = "thumbs_up"
    static let thumbsDown = "thumbs_down"
    static let hotwordFileName = "susi.pmdl"
    static let settings = "Settings"
    static let skillListing = "SUSI.AI Skills"
    static let chooseRoom = "Choose Room"
    static let trainHotword = "Let's train SUSI"
    static let passwordDoNotMatch = "Passwords do not match."
    static let resetPassword = "Reset Password"
    static let currentPassword = "Current Password"
    static let newPassword = "New Password"
    static let passwordLengthShort = "Allowed password length is 6 to 64 characters"
    static let skillDetailControllerIdentifier = "skillDetail"
    static let customServerURL = "Custom Server URL"
    static let tryIt = "Try It"
    static let invalidIP = "Invalid IP Address or URL"
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
    static let addNewDevice = "Add New Device"
    static let devices = "Devices"
    static let selectALanguage = "Select a Language"
    static let deviceType = "iOS"
    static let skillFeedback = "Skill Feedback"
    static let emailAlreadyExists = "Email is already registered!"
    static let noResultFound = "No Result Found Please Try Changing Different Language"

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
        static let login = "Login"
        static let chatSettings = "Chat Settings"
        static let micSettings = "Mic Settings"
        static let speechSettings = "Speech Settings"
        static let susiVoiceModel = "SUSI Voice Model"
        static let miscellaneous = "Miscellaneous"
        static let devices = "Devices"
        static let about = "About Us"
        static let account = "Account Settings"
        static let message = "Please login to continue"
        static let gravatarURL = "https://www.gravatar.com/avatar"
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
        static let successSignup = "You successfully signed-up! An email with a verification link was sent to your address."
        static let verificationLink = "Your request for a new verification link has been processed! An email with a verification link was sent to your address."
        static let errorMessage = "Already registered email! please provide a new email."
    }

    struct UserDefaultsKeys {
        static let user = "user"
        static let enterToSend = "enterAsSend"
        static let micInput = "micInput"
        static let speechOutput = "speechOutput"
        static let speechToTextAvailable = "speechToTextAvailable"
        static let speechOutputAlwaysOn = "speechOutputAlways"
        static let speechRate = "speechRate"
        static let speechPitch = "speechPitch"
        static let wallpaper = "wallpaper"
        static let ipAddress = "ipAddress"
        static let hotwordEnabled = "hotwordRecognition"
        static let ttsLanguage = "ttsLanguage"
        static let prefLanguage = "prefLanguage"
        static let lanuchedBefore = "lanuchedBefore"
        static let typedEmailAdress = "typedEmailAdress"
        static let languageName = "languageName"
        static let languageCode = "languageCode"
        static let room = "room"
        static let userQuery = "userQuery"
        static let bookmark = "bookmark"
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

    struct Onboarding {
        static let login = "Login"
        static let chatInterface = "Chat Interface"
        static let skillListing = "Skill Listing"
        static let chatSettings = "Chat Settings"
        static let loginDescription = "Login into the app using SUSI.AI account or else signup to create a new account or just skip login"
        static let chatInterfaceDescription = "Interact with SUSI.AI asking queries. Use microphone button for voice interaction"
        static let skillListingDescription = "Browse and try your favorite SUSI.AI Skill"
        static let chatSettingsDescription = "Personalize your chat settings for better experience"
    }

    struct ChooseLanguage {
        static let languageName = "languageName"
        static let languageCode = "languageCode"
    }

    struct DeviceActivity {
        static let susiSSID = "SUSI.AI"
        static let deviceCellIndentifier = "DeviceCell"
        static let connectedDetailText = "Click here to procceed with setup"
        static let doneSetupDetailText = "The Smart Speaker is successfully connected to your Wi-Fi and was added to your SUSI.AI user account"
        static let successfullyConnected = "Successfully Connected"
        static let notConnectedDetailText = "Click on '+' icon to add new device"
        static let noDeviceTitle = "No device connected yet"
        static let wifiAlertTitle = "Enter Wi-Fi Password"
        static let wifiAlertMessage = "Please enter the password of the Wi-Fi network you would like to use with your smart speaker."
        static let passwordAlertTitle = "Enter Password"
        static let passwordAlertMessage = "This is the final step, please enter your SUSI.AI account's password to successfully connect to the speaker"
        static let wifiSSIDPlaceholder = "Enter Wi-Fi SSID"
        static let wifiPasswordPlaceholder = "Enter Wi-Fi Password"
        static let userPasswordPlaceholder = "Enter Password"
        static let roomAlertTitle = "What room is your SUSI Smart Speaker in?"
        static let roomAlertMessage = "Choose a location for your SUSI smart speaker. This helps name your SUSI Smart Speaker so it's easier to identify in the SUSI App."
        static let enterRoomPlaceholder = "Enter Room Location"
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
        static let settingsIcon = UIImage(named: "settings_icon")
        static let plusIcon = UIImage(named: "plus_icon")
        static let youtubePlayButton = UIImage(named: "youtube_play_button")
        static let availableDevice = UIImage(named: "available_device_icon")
        static let deviceIcon = UIImage(named: "device_icon")
        static let roomsIcon = UIImage(named: "room-icon")
        static let bookmark = UIImage(named: "star_full")
        static let unBookmark = UIImage(named: "star_empty")
    }
    
    struct AboutUs {
        static let susiDescription = "SUSI.AI is an intelligent libre software personal assistant. It is capable of chat and voice interaction by using APIs to perform actions such as music playback , making to-do lists , setting alarms , streaming podcasts, playing audiobooks , and providing weather , traffic and other real time information. Additional functionalities can be added as console services using external APIs. SUSI.AI is able to answer questions and depending upon the context will ask for additional information in order to perform the desired outcome. The core of the assistant is the SUSI.AI server that holds the intelligence and personality of SUSI.AI."
        static let contributersDescription = "Developed by Contributors."
        static let susiSkillDescription = "SUSI is having many skills. You can look at the collection of skills at skills.susi.ai. SUSI skill development is easy and fun. You can edit existing skills or even create your own."
        static let reportIssueDescription = "Please report all the issues in Github Repository Issue Tracker."
        static let licenseDescription = "This project is currently licensed under the Apache License Version 2.0.As per the LICENSE.md"
    }
    
    struct CommonURL {
        static let susiURL = "https://chat.susi.ai"
        static let susiSkillURL = "www.skills.susi.ai"
        static let contributorsURL = "https://github.com/fossasia/susi_iOS/graphs/contributors"
        static let reportIssueURL = "https://github.com/fossasia/susi_iOS/issues"
        static let licenseURL = "https://github.com/fossasia/susi_iOS/blob/master/LICENSE"
    }

    struct ShareSkill {
        static let message = "Hey! checkout this worderful Susi Skill "
    }
    
    struct Logout {
        static let title = "Logout"
        static let message = "Are you sure, you want to log out?"
        static let cancel = "Cancel"
        static let confirm = "Confirm"
    }
    
    struct showCase {
        static let skillButtonTitle = "Susi Skill Button"
        static let skillButtonMessage = "Click here for Susi Skills"
        static let skillButtonKey = "displayed"
        static let susiButtonTitle = "Susi Button"
        static let susiButtonMessage = "Click here to enable Susi"
        static let susiButtonKey = "displayed1"
    }
        
    struct KeyChainKey {
        static let userEmail = "userEmail"
        static let userPassword = "userPassword"

    }
    
    struct BookmarkSkill {
        static let bookmarkValue = "1"
        static let unBookmarkValue = "0"
        static let bookmarkSuccessMessage = "Bookmark Added Successfully "
        static let unBookmarkSuccessMessage = "Bookmark Removed Successfully"
    }
    
}


