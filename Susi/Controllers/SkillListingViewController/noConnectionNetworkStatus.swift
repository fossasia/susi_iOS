//
//  noConnectionNetworkStatus.swift
//  Susi
//
//  Created by Shivansh Mishra on 19/02/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit
import Reachability

extension noConnectionViewController {

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(internetConnection), name: Notification.Name.reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print(error)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }

    @objc func internetConnection(notification: NSNotification) {
        guard let reachability = notification.object as? Reachability else {return}
        if reachability.connection != .none {
            print("internet connection is available")
            connectionStatus = true
        } else {
            print("internet connection is not available")
        }
    }

}
