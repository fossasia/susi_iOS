//
//  WebsearchCollectionView.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-12.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import SwiftLinkPreview
import RealmSwift

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

    let slp = SwiftLinkPreview()
    var slpResonse = SwiftLinkPreview.Response()

    var message: Message?

    let cellId = "cellId"

    override init(frame: CGRect) {
        super.init(frame: frame)

        collectionView.register(WebsearchCell.self, forCellWithReuseIdentifier: cellId)

        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let rssData = message?.rssData {
            return rssData.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! WebsearchCell

        cell.backgroundColor = .white

        let feed = message?.rssData?.rssFeed[indexPath.item]

        if let webData = feed?.webData {
            cell.webData = webData
        } else {
            slp.preview(feed?.link, onSuccess: { (response) in
                // handle success
                cell.slpResonse = response

                try! self.realm.write {
                    feed?.webData = WebsearchAction()
                    if let title = response[.title] as? String {
                        feed?.webData?.title = title
                    }
                    if let description = response[.description] as? String {
                        feed?.webData?.desc = description
                    }
                    feed?.webData?.image = response[.image] as? String
                    if let url = response[.finalUrl] as? String {
                        feed?.webData?.shortenedURL = url
                    }
                }

            }) { (error) in
                // handle error
                print(error.localizedDescription)
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width * 3 / 5, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }

}
