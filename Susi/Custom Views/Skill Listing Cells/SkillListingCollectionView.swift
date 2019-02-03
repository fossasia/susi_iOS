//
//  SkillListingCollectionView.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-24.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material

protocol SkillSelectionProtocol: class {
    func didSelectSkill(skill: Skill?)
}

class SkillListingCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    let cellId = "cellId"

    var groupSkills: [Skill]? {
        didSet {
            delegate = self
            dataSource = self
            self.reloadData()
        }
    }
    weak var selectionDelegate: SkillSelectionProtocol?
    
    var isLoading: Bool = false

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupSkills?.count ?? (isLoading ? 3 : 0)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SkillCell {
            cell.skill = groupSkills?[indexPath.item]
            cell.backgroundColor = Color.grey.lighten4
            cell.depthPreset = .depth4
            cell.isLoading = isLoading
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width * 4 / 7, height: frame.height - 14)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 7, left: 8, bottom: 7, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectionDelegate?.didSelectSkill(skill: groupSkills?[indexPath.row])
    }

}
