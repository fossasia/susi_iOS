//
//  SkillDetailViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-30.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Kingfisher

class SkillDetailViewController: UIViewController {

    var skill: Skill?
    var chatViewController: ChatViewController?

    lazy var tryItButton: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Try It", style: .plain, target: self, action: #selector(trySkillFromExample))
        item.tintColor = .white
        return item
    }()

    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var skillImageView: UIImageView!
    @IBOutlet weak var skillAuthorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        navigationItem.rightBarButtonItems = [tryItButton]
    }

    func setupView() {
        if let skill = skill {
            skillLabel.text = skill.skillName
            if let url = URL(string: skill.imagePath) {
                skillImageView.kf.setImage(with: url)
            }
            skillAuthorLabel.text = "By: \(skill.author)"
        }
        navigationItem.backButton.tintColor = .white
    }

    func trySkillFromExample() {
        navigationController?.dismiss(animated: true, completion: {
            self.chatViewController?.inputTextField.text = self.skill?.examples.first
            self.chatViewController?.handleSend()
        })
    }

}
