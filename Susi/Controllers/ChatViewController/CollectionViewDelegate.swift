//
//  CollectionViewDelegate.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-07-20.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

extension ChatViewController {

    // Setup Collection View
    func setupTableView() {
        tableView?.backgroundColor = .white
        tableView?.separatorColor = .clear
        tableView?.delegate = self
        tableView?.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height - 68)
        tableView?.register(IncomingBubbleCell.self, forCellReuseIdentifier: ControllerConstants.incomingCell)
        tableView?.register(OutgoingChatCell.self, forCellReuseIdentifier: ControllerConstants.outgoingCell)
        tableView?.register(RSSCell.self, forCellReuseIdentifier: ControllerConstants.rssCell)
        tableView?.register(ActivityIndicatorCell.self, forCellReuseIdentifier: ControllerConstants.indicatorCell)
        tableView?.register(MapCell.self, forCellReuseIdentifier: ControllerConstants.mapCell)
        tableView?.register(AnchorCell.self, forCellReuseIdentifier: ControllerConstants.anchorCell)
        tableView?.register(StopCell.self, forCellReuseIdentifier: ControllerConstants.stopCell)
        tableView?.accessibilityIdentifier = ControllerConstants.TestKeys.chatCollectionView
    }

    // Number of items
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // print("Number of messages: \(messages.count)")
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        if message.actionType == ActionType.indicatorView.rawValue {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ControllerConstants.indicatorCell, for: indexPath) as? ActivityIndicatorCell {
                return cell
            }
        } else if message.fromUser {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ControllerConstants.outgoingCell, for: indexPath) as? OutgoingChatCell {
                cell.message = message
                let estimatedFrame = self.estimatedFrame(message: message.message)
                cell.setupCell(estimatedFrame, view.frame)
                return cell
            }
        } else if message.actionType == ActionType.rss.rawValue || message.actionType == ActionType.websearch.rawValue {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ControllerConstants.rssCell, for: indexPath) as? RSSCell {
                cell.message = message
                return cell
            }
        } else if message.actionType == ActionType.map.rawValue {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ControllerConstants.mapCell, for: indexPath) as? MapCell {
                cell.message = message
                return cell
            }
        } else if message.actionType == ActionType.anchor.rawValue {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ControllerConstants.anchorCell, for: indexPath) as? AnchorCell {
                let estimatedFrame = self.estimatedFrame(message: message.message)
                cell.message = message
                cell.setupCell(estimatedFrame)
                return cell
            }
        } else if message.actionType == ActionType.stop.rawValue {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ControllerConstants.stopCell, for: indexPath) as? StopCell {
                cell.message = message
                let message = ControllerConstants.stopMessage
                let estimatedFrame = self.estimatedFrame(message: message)
                cell.setupCell(estimatedFrame, view.frame)
                return cell
            }
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: ControllerConstants.incomingCell, for: indexPath) as? IncomingBubbleCell {
            cell.message = message
            let message = message.message
            let estimatedFrame = self.estimatedFrame(message: message)
            cell.setupCell(estimatedFrame, view.frame)
            return cell
        }
        return UITableViewCell()
    }
    

    // Calculate Bubble Height
    func tableView(_ tableView: UITableView, sizeForRowAt indexPath: IndexPath) -> CGSize {
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
            }
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 38)
        }
    }

  

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.susiSkillListingButton.isHidden = true
        }, completion: nil)
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.susiSkillListingButton.isHidden = false
        }, completion: nil)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row > messages.count - 2 {
            scrollButton.isHidden = true
        } else {
            scrollButton.isHidden = false
        }
    }

}
