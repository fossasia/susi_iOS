//
//  PopoverTableViewExtension.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-07-19.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift
import Material
import RealmSwift

extension ChatViewController {

    // Enum for menu options in main chat screen
    enum MenuOptions: Int {
        case setttings = 0
        case wallpaper = 1
        case share = 2
        case logout = 3
    }

    // Setup Settings View
    func showSettingsView(_ sender: IconButton) {
        let config = FTConfiguration.shared
        config.textColor = UIColor.black
        config.backgoundTintColor = UIColor.white
        config.borderColor = UIColor.lightGray
        config.menuWidth = 120
        config.menuSeparatorColor = UIColor.lightGray
        config.textAlignment = .center
        config.textFont = UIFont.systemFont(ofSize: 14)
        config.menuRowHeight = 40
        config.cornerRadius = 6

        FTPopOverMenu.showForSender(sender: sender, with: menuOptionNameArray, menuImageArray: menuOptionNameArray, done: { (selectedIndex) -> Void in

            switch selectedIndex {
            case MenuOptions.setttings.rawValue:
                let settingsController = SettingsViewController(collectionViewLayout: UICollectionViewFlowLayout())
                self.navigationController?.pushViewController(settingsController, animated: true)
                break
            case MenuOptions.wallpaper.rawValue:
                self.showWallpaperOptions()
                break
            case MenuOptions.logout.rawValue:
                self.logoutUser()
                break
            default:
                break
            }

        }) {}
    }

    func logoutUser() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }

        Client.sharedInstance.logoutUser { (success, error) in
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    debugPrint(error)
                }
            }
        }
        self.messages.removeAll()
    }

}
