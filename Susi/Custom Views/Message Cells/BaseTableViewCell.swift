//
//  BaseTableViewCell.swift
//  Susi
//
//  Created by pankova on 13/10/2018.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit
import Material

class BaseTableViewCell: TableViewCell {

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
