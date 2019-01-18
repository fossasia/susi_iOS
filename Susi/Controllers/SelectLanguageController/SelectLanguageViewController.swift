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

class SelectLanguageViewController: UIViewController {
   
    let reachability = Reachability()!
    
    var languageModel: [LanguageModel] = []
    var searchedlanguageModel: [LanguageModel] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var isSearching = false
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
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
}
extension SelectLanguageViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        searchedlanguageModel = languageModel.filter({
            if let text = $0.languageName?.prefix(searchText
                .count) {
                return text.caseInsensitiveCompare(searchText) == .orderedSame
            }
            return false
        })
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
extension SelectLanguageViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: - TableView Methods
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchedlanguageModel.count : languageModel.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = !isSearching ? languageModel[indexPath.row].languageName : searchedlanguageModel[indexPath.row].languageName
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLanguageModel = !isSearching ? languageModel[indexPath.row] : searchedlanguageModel[indexPath.row]
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
