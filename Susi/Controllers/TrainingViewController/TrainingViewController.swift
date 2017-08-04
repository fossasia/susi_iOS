//
//  TrainingViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-03.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import AVFoundation

class TrainingViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    var audioRecorder: AVAudioRecorder!
    var count = 0

    // Get directory
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        addCancelNavItem()
        setupUI()
    }

}
