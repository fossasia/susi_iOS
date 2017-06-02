//
//  SettinsHeaderView.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-15.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

class SettingsHeaderView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let settingsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 0, green: 150, blue: 136)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    func setupView() {
        addSubview(settingsLabel)
        addConstraintsWithFormat(format: "H:|-8-[v0]|", views: settingsLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: settingsLabel)
    }

}
