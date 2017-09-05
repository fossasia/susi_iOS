//
//  SkillDetailViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-30.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Kingfisher
import Material

class SkillDetailViewController: UIViewController {

    var skill: Skill?
    var chatViewController: ChatViewController?
    var selectedExample: String?

    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var skillImageView: UIImageView!
    @IBOutlet weak var skillAuthorLabel: UILabel!
    @IBOutlet weak var tryItButton: FlatButton!
    @IBOutlet weak var skillDescription: UILabel!
    @IBOutlet weak var examplesCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTryItTarget()
        addSkillDescription()
    }

}
