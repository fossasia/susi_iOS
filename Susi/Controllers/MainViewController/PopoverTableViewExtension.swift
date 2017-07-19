//
//  PopoverTableViewExtension.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-07-19.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import RealmSwift

extension ChatViewController: UITableViewDelegate {

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

extension ChatViewController: UITableViewDataSource {

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
