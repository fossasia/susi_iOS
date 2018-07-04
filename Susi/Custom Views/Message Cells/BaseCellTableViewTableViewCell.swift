//
//  BaseCellTableViewTableViewCell.swift
//  Susi
//
//  Created by Apple on 23/06/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit
import Material

class BaseCellTableViewTableViewCell: TableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        pulseAnimation = .none
    }


}
