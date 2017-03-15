//
//  SettingsCell.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-15.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

class SettingsCell: BaseCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .gray
        return label
    }()
    
    let settingSwitch: UISwitch = {
        let ss = UISwitch()
        return ss
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(settingSwitch)
        
        addConstraintsWithFormat(format: "H:|-8-[v0][v1]-8-|", views: titleLabel, settingSwitch)
        addConstraintsWithFormat(format: "H:|-8-[v0]", views: detailLabel)
        
        addConstraintsWithFormat(format: "V:|-4-[v0]-4-[v1]", views: titleLabel, detailLabel)
        addConstraintsWithFormat(format: "V:|-8-[v0]", views: settingSwitch)
    }
    
}
