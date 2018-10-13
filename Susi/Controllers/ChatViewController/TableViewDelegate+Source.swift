//
//  TableViewDelegate+Source.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-07-20.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {

    // Configure Table View
    func configureTableView() {
        tableView.backgroundColor = .clear
        tableView.delegate = self
		tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height - 68)
        tableView.register(IncomingBubbleCell.self, forCellReuseIdentifier: ControllerConstants.incomingCell)
        tableView.register(OutgoingChatCell.self, forCellReuseIdentifier: ControllerConstants.outgoingCell)
        tableView.register(RSSCell.self, forCellReuseIdentifier: ControllerConstants.rssCell)
        tableView.register(ActivityIndicatorCell.self, forCellReuseIdentifier: ControllerConstants.indicatorCell)
        tableView.register(MapCell.self, forCellReuseIdentifier: ControllerConstants.mapCell)
        tableView.register(AnchorCell.self, forCellReuseIdentifier: ControllerConstants.anchorCell)
        tableView.register(StopCell.self, forCellReuseIdentifier: ControllerConstants.stopCell)
        tableView.register(ImageCell.self, forCellReuseIdentifier: ControllerConstants.imageCell)
        tableView.register(YouTubePlayerCell.self, forCellReuseIdentifier: ControllerConstants.youtubePlayerCell)
        tableView.accessibilityIdentifier = ControllerConstants.TestKeys.chatCollectionView
		tableView.separatorStyle = .none
		tableView.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 16, right: 0)
		if #available(iOS 11.0, *) {
			tableView.contentInsetAdjustmentBehavior = .never
		} else {
			automaticallyAdjustsScrollViewInsets = false
		}

    }

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    // Configure Cell
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        } else if let expression = message.answerData?.expression, expression.isValidURL(), expression.isImage() {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ControllerConstants.imageCell, for: indexPath) as? ImageCell {
                cell.message = message
                return cell
            }
        } else if message.actionType == ActionType.video_play.rawValue || message.actionType == ActionType.audio_play.rawValue {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ControllerConstants.youtubePlayerCell, for: indexPath) as? YouTubePlayerCell {
                cell.message = message
                cell.delegate = self
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

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let message = messages[indexPath.row]

		if message.actionType == ActionType.indicatorView.rawValue {
			return CGFloat(44)
		} else {
			let estimatedFrame = self.estimatedFrame(message: message.message)
			if message.actionType == ActionType.map.rawValue {
				return CGFloat(200)
			} else if message.actionType == ActionType.rss.rawValue ||
				message.actionType == ActionType.websearch.rawValue {
				return CGFloat(145)
			} else if let expression = message.answerData?.expression, expression.isValidURL(), expression.isImage() {
				return CGFloat(173)
			} else if message.actionType == ActionType.video_play.rawValue || message.actionType == ActionType.audio_play.rawValue {
				return CGFloat(58)
			}
			return CGFloat(estimatedFrame.height + 38)
		}
	}

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.susiSkillListingButton.isHidden = true
        }, completion: nil)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.susiSkillListingButton.isHidden = false
        }, completion: nil)
    }

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row > messages.count - 2 {
            scrollButton.isHidden = true
        } else {
            scrollButton.isHidden = false
        }
    }

}
