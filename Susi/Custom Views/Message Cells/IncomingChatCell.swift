//
//  IncomingChatCell.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-04.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import NukeGifuPlugin
import MapKit

class IncomingBubbleCell: ChatMessageCell, MKMapViewDelegate {

    var message: Message? {
        didSet {
            messageTextView.text = message?.message

            if let imageString = message?.message, imageString.isImage() {
                if let url = URL(string: imageString) {
                    AnimatedImage.manager.loadImage(with: url, into: imageView)
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
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()

    lazy var websearchView: WebsearchCollectionView = {
        let view = WebsearchCollectionView()
        view.message = self.message
        return view
    }()

    override func setupViews() {
        super.setupViews()

        self.bubbleImageView.image = ChatMessageCell.grayBubbleImage
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
        }
    }

    func addImageView() {
        messageTextView.text = ""
        textBubbleView.addSubview(imageView)
        textBubbleView.addConstraintsWithFormat(format: "H:|-8-[v0]-5-|", views: imageView)
        textBubbleView.addConstraintsWithFormat(format: "V:|-4-[v0]-5-|", views: imageView)
    }

    func addWebsearchView() {
        self.addSubview(websearchView)
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: websearchView)
        self.addConstraintsWithFormat(format: "V:[v0(150)]", views: websearchView)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.prepareForReuse()
    }

    func setupCell(_ estimatedFrame: CGRect, _ viewFrame: CGRect) {

        self.clearViews()
        self.bubbleImageView.tintColor = .white
        self.messageTextView.textColor = .black

        if let message = message {
            if message.message.isImage() {
                let width = Int(frame.width / 2)
                let height = 150
                self.messageTextView.frame = CGRect.zero
                self.textBubbleView.frame = CGRect(x: 4, y: -4, width: width + 40, height: height)
                self.bubbleImageView.isHidden = true
                self.addImageView()
            } else  if message.actionType == ActionType.answer.rawValue {
                self.messageTextView.frame = CGRect(x: 16, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 30)
                self.textBubbleView.frame = CGRect(x: 4, y: -4, width: estimatedFrame.width + 40, height: estimatedFrame.height + 26)
                self.bubbleImageView.isHidden = false

                if message.message.containsURL() {
                    let attributedString = NSMutableAttributedString(string: message.message)
                    _ = attributedString.setAsLink(textToFind: message.message.extractFirstURL(),
                                                   linkURL: message.message.extractFirstURL(), text: message.message)
                    self.messageTextView.attributedText = attributedString
                } else {
                    let attributedString = NSMutableAttributedString(string: message.message)
                    attributedString.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 16.0)],
                                                   range: NSRange(location: 0, length: message.message.characters.count))
                    self.messageTextView.attributedText = attributedString
                }

            } else if message.actionType == ActionType.map.rawValue {
                self.messageTextView.frame = CGRect.zero
                self.textBubbleView.frame = CGRect(x: 4, y: -4, width: 300, height: 232)
                self.bubbleImageView.isHidden = false
                self.addMapView(CGRect(x: 16, y: 12, width: 272, height: 210))
            } else if message.actionType == ActionType.anchor.rawValue {
                self.messageTextView.frame = CGRect(x: 16, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 30)
                self.textBubbleView.frame = CGRect(x: 4, y: -4, width: estimatedFrame.width + 40, height: estimatedFrame.height + 32)
                bubbleImageView.isHidden = false
                let attributedString = NSMutableAttributedString(string: message.anchorData!.text)
                _ = attributedString.setAsLink(textToFind: message.anchorData!.text, linkURL: message.anchorData!.link, text: message.message)
                self.messageTextView.attributedText = attributedString
            } else if message.actionType == ActionType.rss.rawValue {
                self.addWebsearchView()
                self.messageTextView.frame = .zero
                self.textBubbleView.frame = .zero
                self.bubbleImageView.frame = .zero
            } else {
                self.messageTextView.frame = .zero
                self.textBubbleView.frame = .zero
                self.bubbleImageView.frame = .zero
            }
        }

    }

    func clearViews() {
        self.mapView.removeFromSuperview()
        self.imageView.removeFromSuperview()
        self.websearchView.removeFromSuperview()
    }

}
