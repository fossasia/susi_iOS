//
//  RSSCell.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-12.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

class RSSCell: ChatMessageCell {

    var message: Message? {
        didSet {
            addWebsearchView()
        }
    }

    lazy var websearchView: WebsearchCollectionView = {
        let view = WebsearchCollectionView()
        return view
    }()

    override func setupViews() {
        super.setupViews()
        prepareForReuse()
    }

    func addWebsearchView() {
        addSubview(websearchView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: websearchView)
        addConstraintsWithFormat(format: "V:[v0(135)]", views: websearchView)
        websearchView.message = message
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }

}
