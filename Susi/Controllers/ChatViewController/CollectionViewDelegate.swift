//
//  CollectionViewDelegate.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-07-20.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

extension ChatViewController: UICollectionViewDelegateFlowLayout {

    // Setup Collection View
    func setupCollectionView() {
        collectionView?.backgroundColor = .clear
        collectionView?.delegate = self
        collectionView?.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height - 68)
        collectionView?.register(IncomingBubbleCell.self, forCellWithReuseIdentifier: ControllerConstants.incomingCell)
        collectionView?.register(OutgoingChatCell.self, forCellWithReuseIdentifier: ControllerConstants.outgoingCell)
        collectionView?.register(RSSCell.self, forCellWithReuseIdentifier: ControllerConstants.rssCell)
        collectionView?.register(ActivityIndicatorCell.self, forCellWithReuseIdentifier: ControllerConstants.indicatorCell)
        collectionView?.register(MapCell.self, forCellWithReuseIdentifier: ControllerConstants.mapCell)
        collectionView?.register(AnchorCell.self, forCellWithReuseIdentifier: ControllerConstants.anchorCell)
        collectionView?.register(StopCell.self, forCellWithReuseIdentifier: ControllerConstants.stopCell)
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: ControllerConstants.imageCell)
        collectionView?.register(YouTubePlayerCell.self, forCellWithReuseIdentifier: ControllerConstants.youtubePlayerCell)
        collectionView?.accessibilityIdentifier = ControllerConstants.TestKeys.chatCollectionView
    }

    // Number of items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // print("Number of messages: \(messages.count)")
        return messages.count
    }

    // Configure Cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let message = messages[indexPath.row]

        if message.actionType == ActionType.indicatorView.rawValue {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControllerConstants.indicatorCell, for: indexPath) as? ActivityIndicatorCell {
                return cell
            }
        } else if message.fromUser {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControllerConstants.outgoingCell, for: indexPath) as? OutgoingChatCell {
                cell.message = message
                let estimatedFrame = self.estimatedFrame(message: message.message)
                cell.setupCell(estimatedFrame, view.frame)
                return cell
            }
        } else if message.actionType == ActionType.rss.rawValue || message.actionType == ActionType.websearch.rawValue {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControllerConstants.rssCell, for: indexPath) as? RSSCell {
                cell.message = message
                return cell
            }
        } else if message.actionType == ActionType.map.rawValue {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControllerConstants.mapCell, for: indexPath) as? MapCell {
                cell.message = message
                return cell
            }
        } else if message.actionType == ActionType.anchor.rawValue {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControllerConstants.anchorCell, for: indexPath) as? AnchorCell {
                let estimatedFrame = self.estimatedFrame(message: message.message)
                cell.message = message
                cell.setupCell(estimatedFrame)
                return cell
            }
        } else if message.actionType == ActionType.stop.rawValue {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControllerConstants.stopCell, for: indexPath) as? StopCell {
                cell.message = message
                let message = ControllerConstants.stopMessage
                let estimatedFrame = self.estimatedFrame(message: message)
                cell.setupCell(estimatedFrame, view.frame)
                return cell
            }
        } else if let expression = message.answerData?.expression, expression.isValidURL(), expression.isImage() {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControllerConstants.imageCell, for: indexPath) as? ImageCell {
                cell.message = message
                return cell
            }
        } else if message.actionType == ActionType.video_play.rawValue || message.actionType == ActionType.audio_play.rawValue {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControllerConstants.youtubePlayerCell, for: indexPath) as? YouTubePlayerCell {
                cell.message = message
                cell.delegate = self
                return cell
            }
        } else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControllerConstants.incomingCell, for: indexPath) as? IncomingBubbleCell {
            cell.message = message
            let message = message.message
            let estimatedFrame = self.estimatedFrame(message: message)
            cell.setupCell(estimatedFrame, view.frame)
            return cell
        }
        return UICollectionViewCell()
    }

    // Calculate Bubble Height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = messages[indexPath.row]

        if message.actionType == ActionType.indicatorView.rawValue {
            return CGSize(width: view.frame.width, height: 44)
        } else {
            let estimatedFrame = self.estimatedFrame(message: message.message)
            if message.actionType == ActionType.map.rawValue {
                return CGSize(width: view.frame.width, height: 200)
            } else if message.actionType == ActionType.rss.rawValue ||
                message.actionType == ActionType.websearch.rawValue {
                return CGSize(width: view.frame.width, height: 145)
            } else if let expression = message.answerData?.expression, expression.isValidURL(), expression.isImage() {
                return CGSize(width: view.frame.width, height: 173)
            } else if message.actionType == ActionType.video_play.rawValue || message.actionType == ActionType.audio_play.rawValue {
                return CGSize(width: view.frame.width, height: 158)
            }
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 38)
        }
    }

    // Set Edge Insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 0, bottom: 16, right: 0)
    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.susiSkillListingButton.isHidden = true
        }, completion: nil)
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.susiSkillListingButton.isHidden = false
        }, completion: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row > messages.count - 2 {
            scrollButton.isHidden = true
        } else {
            scrollButton.isHidden = false
        }
    }

}
