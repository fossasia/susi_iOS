//
//  WebsearchCell.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-12.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import ReadabilityKit
import RealmSwift
import Kingfisher
import Material

class WebsearchCell: BaseCell {

    var imageString: String?

    var feed: RSSFeed? {
        didSet {
            if let link = feed?.link, let url = URL(string: link) {
                Readability.parse(url: url) { (data) in
                    if let imageString = data?.topImage {
                        let url = URL(string: imageString)
                        if let url = url {
                            self.imageView.kf.setImage(with: url, placeholder: ControllerConstants.Images.placeholder, options: nil, progressBlock: nil, completionHandler: nil)
                        }
                    }

                    let realm = try! Realm()
                    try! realm.write {

                        let webData = WebsearchAction()

                        if let title = data?.title, !title.isEmpty {
                            webData.title = title
                            self.titleLabel.text = title
                        } else {
                            webData.title = self.feed!.title
                        }

                        if let description = data?.description, !description.isEmpty {
                            webData.desc = description
                            self.descriptionLabel.text = description
                        } else {
                            webData.desc = self.feed!.desc
                        }

                        if let image = data?.topImage {
                            webData.image = image
                            self.imageString = image
                        } else {
                            webData.image = nil
                        }

                        webData.shortenedURL = self.feed!.link
                        self.feed?.webData = webData
                    }
                    self.setupCell()
                }
            }
        }
    }

    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = ControllerConstants.Images.placeholder
        return iv
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.backgroundColor = Color.grey.lighten3
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()

    func setupCell() {
        for view in subviews {
            view.removeFromSuperview()
        }
        if let image = imageString, image.isImage() {
            addSubview(imageView)
            addSubview(titleLabel)
            addSubview(descriptionLabel)
            descriptionLabel.numberOfLines = 5
            addConstraintsWithFormat(format: "H:|-4-[v0(\(frame.width * 0.4))]-4-[v1]-4-|", views: imageView, titleLabel)
            addConstraintsWithFormat(format: "|-\(frame.width * 0.4 + 8)-[v0]-4-|", views: descriptionLabel)
            addConstraintsWithFormat(format: "V:|-4-[v0]-4-|", views: imageView)
            addConstraintsWithFormat(format: "V:|-4-[v0(44)]-4-[v1]-4-|", views: titleLabel, descriptionLabel)
        } else {
            imageView.removeFromSuperview()
            addSubview(titleLabel)
            addSubview(descriptionLabel)
            descriptionLabel.numberOfLines = 6
            addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: titleLabel)
            addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: descriptionLabel)
            addConstraintsWithFormat(format: "V:|-4-[v0(44)]-4-[v1]-4-|", views: titleLabel, descriptionLabel)
        }
    }

}
