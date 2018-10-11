//
//  SkillDetailVCCollectionView.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-09-01.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

extension SkillDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skill?.examples.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? SkillDetailExampleCell {
            cell.exampleLabel.text = skill?.examples[indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let example = skill?.examples[indexPath.row]
        let frame = estimatedFrame(query: example!)
        return CGSize(width: frame.width + 28, height: 44)
    }

    // estimates frame of message
    func estimatedFrame(query: String) -> CGRect {
        let size = CGSize(width: 450, height: 44)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: query).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], context: nil)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let example = skill?.examples[indexPath.item]
        selectedExample = example
        trySkillFromExample()
    }

}
