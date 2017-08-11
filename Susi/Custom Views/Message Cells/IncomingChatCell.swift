//
//  IncomingChatCell.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Kingfisher
import MapKit
import SwiftDate
import NVActivityIndicatorView
import Material

class IncomingBubbleCell: ChatMessageCell, MKMapViewDelegate {

    var message: Message? {
        didSet {
            messageTextView.text = message?.message
            if let imageString = message?.message, imageString.isImage() {
                if let url = URL(string: imageString) {
                    imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
                }
            }
            setupTheme()
        }
    }

    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = false
        mapView.layer.cornerRadius = 15
        mapView.layer.masksToBounds = true
        return mapView
    }()

    let imageView: AnimatedImageView = {
        let imageView = AnimatedImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()

    lazy var thumbUpIcon: IconButton = {
        let button = IconButton()
        button.image = UIImage(named: ControllerConstants.thumbsUp)?.withRenderingMode(.alwaysTemplate)
        button.addTarget(self, action: #selector(sendFeedback(sender:)), for: .touchUpInside)
        button.tintColor = UIColor(white: 0.1, alpha: 0.7)
        return button
    }()

    lazy var thumbDownIcon: IconButton = {
        let button = IconButton()
        button.image = UIImage(named: ControllerConstants.thumbsDown)?.withRenderingMode(.alwaysTemplate)
        button.addTarget(self, action: #selector(sendFeedback(sender:)), for: .touchUpInside)
        button.tintColor = UIColor(white: 0.1, alpha: 0.7)
        return button
    }()

    override func setupViews() {
        super.setupViews()
        setupTheme()
    }

    func addMapView(_ frame: CGRect) {
        textBubbleView.addSubview(mapView)

        mapView.frame = frame
        mapView.isZoomEnabled = false

        if let mapData = message?.mapData {
            let latitude = mapData.latitude
            let longitude = mapData.longitude

            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let zoomLevel = 360 / pow(2, Double(mapData.zoom)) * Double(frame.width) / 256
            let span = MKCoordinateSpanMake(0, zoomLevel)
            let region = MKCoordinateRegion(center: center, span: span)

            mapView.setRegion(region, animated: true)

            // add annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            mapView.addAnnotation(annotation)

            mapView.showsUserLocation = true
        }
    }

    func addImageView() {
        messageTextView.text = ""
        textBubbleView.addSubview(imageView)
        textBubbleView.addConstraintsWithFormat(format: "H:|-8-[v0]-5-|", views: imageView)
        textBubbleView.addConstraintsWithFormat(format: "V:|-4-[v0]-5-|", views: imageView)
    }

    func setupCell(_ estimatedFrame: CGRect, _ viewFrame: CGRect) {
        clearViews()
        if let message = message {
            if message.message.isImage() {
                let width = Int(frame.width / 2)
                let height = 150
                messageTextView.frame = CGRect.zero
                textBubbleView.frame = CGRect(x: 4, y: -4, width: width + 40, height: height)
                addImageView()
            } else  if message.actionType == ActionType.answer.rawValue {
                messageTextView.frame = CGRect(x: 12, y: 0, width: max(estimatedFrame.width + 30, viewFrame.width / 3), height: estimatedFrame.height + 10)
                textBubbleView.frame = CGRect(x: 8, y: -4, width: max(estimatedFrame.width + 40, viewFrame.width / 3), height: estimatedFrame.height + 26)

                let attributedString = NSMutableAttributedString(string: message.message)
                if message.message.containsURL() {
                    _ = attributedString.setAsLink(textToFind: message.message.extractFirstURL(),
                                                   linkURL: message.message.extractFirstURL(), text: message.message)
                } else {
                    attributedString.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 16.0)],
                                                   range: NSRange(location: 0, length: message.message.characters.count))
                }

                messageTextView.attributedText = attributedString
                addBottomView()
            } else if message.actionType == ActionType.map.rawValue {
                messageTextView.frame = CGRect.zero
                textBubbleView.frame = CGRect(x: 8, y: -4, width: 268, height: 196)
                addMapView(CGRect(x: 8, y: 8, width: 252, height: 180))
            } else if message.actionType == ActionType.anchor.rawValue {
                messageTextView.frame = CGRect(x: 12, y: 0, width: estimatedFrame.width + 30, height: estimatedFrame.height + 20)
                textBubbleView.frame = CGRect(x: 8, y: -4, width: estimatedFrame.width + 40, height: estimatedFrame.height + 32)
                let attributedString = NSMutableAttributedString(string: message.anchorData!.text)
                _ = attributedString.setAsLink(textToFind: message.anchorData!.text, linkURL: message.anchorData!.link, text: message.message)
                messageTextView.attributedText = attributedString
                addBottomView()
            }
        }
    }

    func clearViews() {
        mapView.removeFromSuperview()
        imageView.removeFromSuperview()
        timeLabel.removeFromSuperview()
        thumbUpIcon.removeFromSuperview()
        thumbDownIcon.removeFromSuperview()
    }

    func setupTheme() {
        textBubbleView.borderWidth = 0.2
        textBubbleView.backgroundColor = .white
        messageTextView.textColor = .black
        timeLabel.textColor = .black
    }

    func addBottomView() {
        let date = DateInRegion(absoluteDate: message?.answerDate as Date!)
        let str = date.string(format: .custom("h:mm a"))
        timeLabel.text = str

        textBubbleView.addSubview(timeLabel)

        if message?.actionType == ActionType.answer.rawValue {
            textBubbleView.addSubview(thumbUpIcon)
            textBubbleView.addSubview(thumbDownIcon)
            textBubbleView.addConstraintsWithFormat(format: "H:[v0]-4-[v1(14)]-2-[v2(14)]-8-|", views: timeLabel, thumbUpIcon, thumbDownIcon)
            textBubbleView.addConstraintsWithFormat(format: "V:[v0(14)]-2-|", views: thumbUpIcon)
            textBubbleView.addConstraintsWithFormat(format: "V:[v0(14)]-2-|", views: thumbDownIcon)
            thumbUpIcon.isUserInteractionEnabled = true
            thumbDownIcon.isUserInteractionEnabled = true
        } else {
            textBubbleView.addConstraintsWithFormat(format: "H:[v0]-8-|", views: timeLabel)
        }
        textBubbleView.addConstraintsWithFormat(format: "V:[v0]-4-|", views: timeLabel)
    }

    func sendFeedback(sender: IconButton) {
        let feedback: String
        if sender == thumbUpIcon {
            thumbDownIcon.tintColor = UIColor(white: 0.1, alpha: 0.7)
            thumbUpIcon.isUserInteractionEnabled = false
            thumbDownIcon.isUserInteractionEnabled = true
            feedback = "positive"
        } else {
            thumbUpIcon.tintColor = UIColor(white: 0.1, alpha: 0.7)
            thumbDownIcon.isUserInteractionEnabled = false
            thumbUpIcon.isUserInteractionEnabled = true
            feedback = "negative"
        }
        sender.tintColor = UIColor.hexStringToUIColor(hex: "#2196F3")

        let skillComponents = message?.skill.components(separatedBy: "/")
        if skillComponents?.count == 7 {
            let params: [String : AnyObject] = [
                Client.FeedbackKeys.model: skillComponents![3] as AnyObject,
                Client.FeedbackKeys.group: skillComponents![4] as AnyObject,
                Client.FeedbackKeys.language: skillComponents![5] as AnyObject,
                Client.FeedbackKeys.skill: skillComponents![6].components(separatedBy: ".").first as AnyObject,
                Client.FeedbackKeys.rating: feedback as AnyObject
            ]

            Client.sharedInstance.sendFeedback(params) { (success, error) in
                DispatchQueue.global().async {
                    if let error = error {
                        print(error)
                    }
                    print("Skill rated: \(success)")
                }
            }
        }
    }

}
