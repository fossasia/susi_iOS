//
//  WebsearchCollectionView.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-12.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class WebsearchCollectionView: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = true
        cv.backgroundColor = .clear
        return cv
    }()

    let realm = try! Realm()

    var message: Message? {
        didSet {
            if message?.actionType == ActionType.websearch.rawValue {
                let params = [
                    Client.WebsearchKeys.Query: message?.message,
                    Client.WebsearchKeys.Format: ControllerConstants.json
                ]

                Client.sharedInstance.websearch(params as [String: AnyObject]) { (results, success, message) in
                    DispatchQueue.global().async {
                        if success {
                            try! self.realm.write {
                                for result in results! {
                                    self.message?.websearchData.append(result)
                                }
                                self.collectionView.reloadData()
                            }
                        } else {
                            debugPrint(message ?? ControllerConstants.errorOccured)
                        }
                    }
                }
            } else {
                self.collectionView.reloadData()
            }
        }
    }

    let cellId = "cellId"

    override init(frame: CGRect) {
        super.init(frame: frame)

        collectionView.register(WebsearchCell.self, forCellWithReuseIdentifier: cellId)

        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        collectionView.accessibilityIdentifier = ControllerConstants.TestKeys.rssCollectionView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let rssData = message?.rssData {
            return rssData.count
        } else if let webData = message?.websearchData {
            return webData.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? WebsearchCell {
            cell.backgroundColor = .white

            if message?.actionType == ActionType.rss.rawValue {
                let feed = message?.rssData?.rssFeed[indexPath.item]
                cell.titleLabel.text = feed?.title
                cell.descriptionLabel.text = feed?.desc
                cell.feed = feed
                cell.setupCell()
                if let webData = feed?.webData {
                    if let imageString = webData.image {
                        let url = URL(string: imageString)
                        cell.imageView.kf.setImage(with: url, placeholder: ControllerConstants.Images.placeholder, options: nil, progressBlock: nil, completionHandler: nil)
                    }
                }
            } else if message?.actionType == ActionType.websearch.rawValue {
                let webData = message?.websearchData[indexPath.item]
                cell.titleLabel.text = webData?.title
                cell.descriptionLabel.text = webData?.desc.html2String
                cell.setupCell()
                if let imageString = webData?.image {
                    cell.imageString = imageString
                    if let url = URL(string: imageString) {
                        cell.imageView.kf.setImage(with: url, placeholder: ControllerConstants.Images.placeholder, options: nil, progressBlock: nil, completionHandler: nil)
                    }
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width * 3 / 5, height: 135)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }

}
