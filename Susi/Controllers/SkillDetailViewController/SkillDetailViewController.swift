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

import UIKit
import Kingfisher
import Material

class SkillDetailViewController: GeneralViewController {

    let rating: UILabel = {
        let label = UILabel()
        label.text = "Rating"
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightSemibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let positiveRating: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let negativeRating: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let contentType: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var skill: Skill?
    var chatViewController: ChatViewController?
    var selectedExample: String?

    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var skillImageView: UIImageView!
    @IBOutlet weak var skillAuthorLabel: UILabel!
    @IBOutlet weak var tryItButton: FlatButton!
    @IBOutlet weak var skillDescription: UILabel!
    @IBOutlet weak var examplesCollectionView: UICollectionView!
    @IBOutlet weak var exampleHeading: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTryItTarget()
        addSkillDescription()

        view.addSubview(rating)
        rating.leftAnchor.constraint(equalTo: exampleHeading.leftAnchor).isActive = true
        rating.topAnchor.constraint(equalTo: examplesCollectionView.bottomAnchor, constant: 35).isActive = true
        rating.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        rating.heightAnchor.constraint(equalToConstant: 22).isActive = true

        addRating()
        addContentType()
    }
    override func localizeStrings() {
        tryItButton.setTitle(ControllerConstants.tryIt.localized(), for: .normal)
    }

}
