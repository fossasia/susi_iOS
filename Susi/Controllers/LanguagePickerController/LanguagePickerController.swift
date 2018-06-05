//
//  LanguagePickerController.swift
//  Susi
//
//  Created by JOGENDRA on 03/06/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit
import AVFoundation

protocol LanguagePickerDelegate: class {
    func selectedVoicelanguage(language: String?)
}

class LanguagePickerController: UITableViewController {

    // Text to speech languages
    var voiceLanguagesList: [Dictionary<String, String>] = []
    var selectedVoiceLanguage = 0

    weak var languagePickerDelegate: LanguagePickerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem?.isEnabled = false
        prepareVoiceList()
    }

    func prepareVoiceList() {
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            let voiceLanguageCode = (voice as AVSpeechSynthesisVoice).language

            if let languageName = Locale.current.localizedString(forLanguageCode: voiceLanguageCode) {
                let dictionary = [ControllerConstants.ChooseLanguage.languageName: languageName, ControllerConstants.ChooseLanguage.languageCode: voiceLanguageCode]

                voiceLanguagesList.append(dictionary)
            }
        }
    }

    @IBAction func doneChoosingLanguage(_ sender: Any) {
        let voiceLanguagesDictionary = voiceLanguagesList[selectedVoiceLanguage]
        let selectedLanguage = voiceLanguagesDictionary[ControllerConstants.ChooseLanguage.languageName]
        languagePickerDelegate?.selectedVoicelanguage(language: selectedLanguage)
        UserDefaults.standard.set(voiceLanguagesList[selectedVoiceLanguage][ControllerConstants.ChooseLanguage.languageCode], forKey: ControllerConstants.UserDefaultsKeys.languageCode)
        UserDefaults.standard.set(voiceLanguagesList[selectedVoiceLanguage][ControllerConstants.ChooseLanguage.languageName], forKey: ControllerConstants.UserDefaultsKeys.languageName)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancleChoosingLanguage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voiceLanguagesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath)
        let voiceLanguagesDictionary = voiceLanguagesList[indexPath.row]
        cell.textLabel?.text = voiceLanguagesDictionary[ControllerConstants.ChooseLanguage.languageName]
        cell.detailTextLabel?.text = voiceLanguagesDictionary[ControllerConstants.ChooseLanguage.languageCode]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedVoiceLanguage = indexPath.row
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let oldIndex = tableView.indexPathForSelectedRow {
            tableView.cellForRow(at: oldIndex)?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        return indexPath
    }

}
