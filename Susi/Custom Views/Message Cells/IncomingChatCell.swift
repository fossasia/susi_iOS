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

class IncomingBubbleCell: ChatMessageCell, MKMapViewDelegate {

    var message: Message? {
        didSet {
            messageTextView.text = message?.message
            if let imageString = message?.message, imageString.isImage() {
                if let url = URL(string: imageString) {
                    imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
                }
            }
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

    func setupDate() {
        let date = DateInRegion(absoluteDate: message?.answerDate as Date!)
        let str = date.string(format: .custom("h:mm a"))
        timeLabel.text = str
        textBubbleView.addSubview(timeLabel)
        textBubbleView.addConstraintsWithFormat(format: "H:[v0]-8-|", views: timeLabel)
        textBubbleView.addConstraintsWithFormat(format: "V:[v0]-4-|", views: timeLabel)
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

                if UserDefaults.standard.string(forKey: ControllerConstants.UserDefaultsKeys.theme) == theme.dark.rawValue {
                    let range = (message.message as NSString).range(of: message.message)
                    attributedString.addAttributes([NSForegroundColorAttributeName: UIColor.white], range: range)
                }

                messageTextView.attributedText = attributedString
                setupDate()
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
                setupDate()
            }
        }
    }

    func clearViews() {
        mapView.removeFromSuperview()
        imageView.removeFromSuperview()
        timeLabel.removeFromSuperview()
    }

    func setupTheme() {
        textBubbleView.borderWidth = 0.2
        let activeTheme = UserDefaults.standard.string(forKey: ControllerConstants.UserDefaultsKeys.theme)
        if activeTheme == theme.light.rawValue {
            textBubbleView.backgroundColor = .white
            messageTextView.textColor = .black
            timeLabel.textColor = .black
        } else if activeTheme == theme.dark.rawValue {
            textBubbleView.backgroundColor = .white
            messageTextView.textColor = .black
            timeLabel.textColor = .black
        }
    }

}
