//
//  DevicesActivityViewController.swift
//  Susi
//
//  Created by JOGENDRA on 29/05/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//
import UIKit
import Material

class DevicesActivityViewController: UITableViewController {

    lazy var backButton: IconButton = {
        let button = IconButton()
        button.image = Icon.cm.arrowBack
        button.tintColor = .white
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()

    lazy var addDeviceButton: UIButton = {
        let button = IconButton()
        button.image = Icon.cm.add
        button.tintColor = .white
        button.addTarget(self, action: #selector(presentInstructionController), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.tableFooterView = UIView(frame: .zero)
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath)
        cell.imageView?.image = UIImage(named: "device_icon")
        if let speakerSSID = fetchSSIDInfo(), speakerSSID == "susi.ai" {
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = speakerSSID
        } else {
            cell.accessoryType = .none
            cell.textLabel?.text = "No device connected yet"
        }
        return cell
    }

}
