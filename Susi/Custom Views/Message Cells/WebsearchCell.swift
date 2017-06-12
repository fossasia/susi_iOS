//
//  WebsearchCell.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-12.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import SwiftLinkPreview
import AlamofireImage

class WebsearchCell: BaseCell {

    var slpResonse: SwiftLinkPreview.Response? {
        didSet {
            titleLabel.text = slpResonse?[.title] as? String
            descriptionLabel.text = slpResonse?[.description] as? String

            if let image = slpResonse?[.image] as? String, image.isImage() {
                if let url = URL(string: image) {
                    let urlRequest = URLRequest(url: url)
                    imageView.af_setImage(withURLRequest: urlRequest)
                }
            }
            self.setupCell()
            self.pulseAnimation = .none
        }
    }

    var webData: WebsearchAction? {
        didSet {
            titleLabel.text = webData?.title
            descriptionLabel.text = webData?.desc

            if let image = webData?.image, image.isImage() {
                if let url = URL(string: image) {
                    let urlRequest = URLRequest(url: url)
                    imageView.af_setImage(withURLRequest: urlRequest)
                }
            }
            self.setupCell()
            self.pulseAnimation = .none
        }
    }

    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "placeholder")
        return iv
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    func loadData() {

    }

    func setupCell() {
        if let _ = slpResonse?[.image] as? String {
            addSubview(imageView)
            addSubview(titleLabel)
            addSubview(descriptionLabel)
            titleLabel.numberOfLines = 2
            descriptionLabel.numberOfLines = 5
            addConstraintsWithFormat(format: "H:|-4-[v0(\(frame.width * 0.4))]-4-[v1]-4-|", views: imageView, titleLabel)
            addConstraintsWithFormat(format: "|-\(frame.width * 0.4 + 8)-[v0]-4-|", views: descriptionLabel)
            addConstraintsWithFormat(format: "V:|-4-[v0]-4-|", views: imageView)
            addConstraintsWithFormat(format: "V:|-4-[v0(44)]-4-[v1]-4-|", views: titleLabel, descriptionLabel)
        } else {
            addSubview(titleLabel)
            addSubview(descriptionLabel)
            titleLabel.numberOfLines = 3
            descriptionLabel.numberOfLines = 6
            addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: titleLabel)
            addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: descriptionLabel)
            addConstraintsWithFormat(format: "V:|-4-[v0(50)]-4-[v1]-4-|", views: titleLabel, descriptionLabel)
        }
    }

}
