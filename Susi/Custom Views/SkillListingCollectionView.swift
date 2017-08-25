//
//  SkillListingCollectionView.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-24.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material

class SkillListingCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    let cellId = "cellId"

    var groupSkills: [Skill]?

    var groupName: String? {
        didSet {
            delegate = self
            dataSource = self
            groupSkills = []
            self.reloadData()
            let params = [
                Client.SkillListing.group: groupName
            ]

            Client.sharedInstance.getSkillData(params as [String : AnyObject]) { (skills, success, message) in
                DispatchQueue.main.async {
                    if success {
                        self.groupSkills = skills
                        self.reloadData()
                    } else {
                        print(message ?? "No error")
                    }
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupSkills?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SkillCell {
            cell.skill = groupSkills?[indexPath.item]
            cell.backgroundColor = Color.grey.lighten2
            cell.depthPreset = .depth4
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width * 5 / 7, height: frame.height - 14)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 7, left: 8, bottom: 7, right: 8)
    }

}
