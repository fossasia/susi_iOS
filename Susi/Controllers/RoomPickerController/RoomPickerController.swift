//
//  RoomPickerController.swift
//  Susi
//
//  Created by JOGENDRA on 29/07/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit

class RoomPickerController: UITableViewController {

    let rooms: [String] = ["Bedroom",
                           "Kitchen",
                           "Family Room",
                           "Entryway",
                           "Living Room",
                           "Front Yard",
                           "Guest Room",
                           "Dining Room",
                           "Computer Room",
                           "Downstairs",
                           "Front Porch",
                           "Garage",
                           "Hallway",
                           "Driveway"]

    var selectedRoom: String?
    var deviceActivityVC: DevicesActivityViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()

        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }

    func setupNavigationBar() {
        navigationItem.titleLabel.text = ControllerConstants.chooseRoom.localized()
        navigationItem.titleLabel.textColor = .white
        if let navbar = navigationController?.navigationBar {
            navbar.barTintColor = UIColor.defaultColor()
        }
    }

    @IBAction func cancelChoosingRooms() {
        self.dismiss(animated: true, completion: {
            self.deviceActivityVC?.presentRoomsPopup()
        })
    }

    @IBAction func doneChoosingRooms() {
        UserDefaults.standard.set(selectedRoom, forKey: ControllerConstants.UserDefaultsKeys.room)
        self.dismiss(animated: true, completion: {
            self.deviceActivityVC?.presentSelectedRoomPopup()
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomsCell", for: indexPath)
        cell.textLabel?.text = rooms[indexPath.row]
        cell.imageView?.image = ControllerConstants.Images.roomsIcon
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRoom = rooms[indexPath.row]
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
