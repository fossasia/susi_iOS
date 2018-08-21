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

    var isSetupDone: Bool = false {
        didSet {
            self.tableView.reloadData()
        }
    }

    var wifiAlertController = UIAlertController()
    var passwordAlertController = UIAlertController()
    var alertController = UIAlertController()
    var roomAlertController = UIAlertController()

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
        let cell = tableView.dequeueReusableCell(withIdentifier: ControllerConstants.DeviceActivity.deviceCellIndentifier, for: indexPath)
        if let speakerSSID = fetchSSIDInfo(), speakerSSID == ControllerConstants.DeviceActivity.susiSSID {
            cell.accessoryType = .disclosureIndicator
            cell.imageView?.image = ControllerConstants.Images.availableDevice
            cell.textLabel?.text = speakerSSID
            cell.detailTextLabel?.text = ControllerConstants.DeviceActivity.connectedDetailText
            if isSetupDone {
                cell.textLabel?.text = ControllerConstants.DeviceActivity.successfullyConnected
                cell.detailTextLabel?.text = ControllerConstants.DeviceActivity.doneSetupDetailText
            }
        } else {
            cell.accessoryType = .none
            cell.textLabel?.text = ControllerConstants.DeviceActivity.noDeviceTitle
            cell.detailTextLabel?.text = ControllerConstants.DeviceActivity.notConnectedDetailText
            cell.imageView?.image = ControllerConstants.Images.deviceIcon
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0, let speakerSSID = fetchSSIDInfo(), speakerSSID == ControllerConstants.DeviceActivity.susiSSID, !isSetupDone {
            // Open a popup to select Rooms
            presentRoomsPopup()
        }
    }

}
