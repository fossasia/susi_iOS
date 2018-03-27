//
//  GeneralViewController.swift
//  Susi
//
//  Created by Aleksei Cherepanov on 28.09.17.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Localize_Swift

class GeneralViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Load \(self)")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(localizeStrings),
                                               name: NSNotification.Name(LCLLanguageChangeNotification),
                                               object: nil)
        localizeStrings()
    }

    @objc func localizeStrings() {
        print("VC localization")
    }
}
