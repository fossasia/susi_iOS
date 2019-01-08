//
//  SelectLanguageViewController.swift
//  Susi
//
//  Created by Raghav on 05/01/19.
//  Copyright © 2019 FOSSAsia. All rights reserved.
//

import UIKit
import Material
import Reachability

class SelectLanguageViewController: UITableViewController {
   
    let reachability = Reachability()!
    
    var languageModel: [LanguageModel] = []
    
    lazy var backButton: IconButton = {
        let ib = IconButton()
        ib.image = Icon.cm.arrowBack
        ib.tintColor = .white
        ib.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        return ib
    }()
        
    var languageSelection: ((LanguageModel)->Void)?
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .whiteLarge
        indicator.color = UIColor.defaultColor()
        return indicator
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareActivityIndicator()
        getData()
        setUpView()
    }
    
    func prepareActivityIndicator() {
        tableView.layout(activityIndicator).center()
    }

    func setUpView() {
        if let navbar = navigationController?.navigationBar {
            navbar.barTintColor = UIColor.defaultColor()
        }
        navigationItem.titleLabel.text = ControllerConstants.selectALanguage.localized()
        navigationItem.leftViews = [backButton]
        tableView.separatorStyle = .none
        tableView.bounces = false
    }
}
extension SelectLanguageViewController {
    //MARK: - TableView Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = languageModel[indexPath.row].languageName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLanguageModel = languageModel[indexPath.row]
        languageSelection?(selectedLanguageModel)
        dismissController()
    }
    
    @objc func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension SelectLanguageViewController {
    func getData() {
        weak var weakSelf = self
        activityIndicator.startAnimating()
        Client.sharedInstance.getAllLanguages([:]) { (success, error, languages) in
            for languageCode in languages ?? [] {
                if(success) {
                    let locale = NSLocale(localeIdentifier: languageCode)
                    if let translated = locale.displayName(forKey: NSLocale.Key.identifier, value: languageCode) {
                        weakSelf?.languageModel.append(LanguageModel(languageCode: languageCode, languageName: translated))
                        weakSelf?.tableView.reloadData()
                        weakSelf?.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}
