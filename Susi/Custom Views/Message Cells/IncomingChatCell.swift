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

//            websiteText.text = message?.websearchData?.info

//            if let imageString = message?.websearchData?.image {
//                if let url = URL(string: imageString) {
//                    let urlRequest = URLRequest(url: url)
//                    searchImageView.af_setImage(withURLRequest: urlRequest)
//                }
//            }

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

    let websearchContentView = UIView()

    let searchImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: ControllerConstants.defaultWebSearchImage)
        return imageView
    }()

    let websiteText: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.webTextColor()
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    let imageView: AnimatedImageView = {
        let imageView = AnimatedImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
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

    func addLinkPreview(_ frame: CGRect) {
        textBubbleView.addSubview(websearchContentView)
        websearchContentView.backgroundColor = UIColor.linkPreviewBackgroundColor()
        websearchContentView.frame = frame

        websearchContentView.layer.cornerRadius = 15
        websearchContentView.layer.masksToBounds = true

        websearchContentView.addSubview(searchImageView)
        websearchContentView.addSubview(websiteText)
        websearchContentView.addConstraintsWithFormat(format: "H:|-4-[v0(44)]-4-[v1]-4-|", views: searchImageView, websiteText)
        websearchContentView.addConstraintsWithFormat(format: "V:|-4-[v0]-4-|", views: searchImageView)
        websearchContentView.addConstraintsWithFormat(format: "V:|-4-[v0(44)]-4-|", views: websiteText)
    }

    func addImageView() {
        messageTextView.text = ""
        textBubbleView.addSubview(imageView)
        textBubbleView.addConstraintsWithFormat(format: "H:|-8-[v0]-5-|", views: imageView)
        textBubbleView.addConstraintsWithFormat(format: "V:|-4-[v0]-5-|", views: imageView)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.prepareForReuse()
    }

    func setupCell(_ estimatedFrame: CGRect, _ viewFrame: CGRect) {

        self.clearViews()
        self.bubbleImageView.tintColor = .white
        self.messageTextView.textColor = .black

        if let message = message {
            if message.message.isImage() {
                let width = Int(frame.width / 2)
                let height = 150
                messageTextView.frame = CGRect.zero
                textBubbleView.frame = CGRect(x: 4, y: -4, width: width + 40, height: height)
                bubbleImageView.isHidden = true
                self.addImageView()
            } else  if message.actionType == ActionType.answer.rawValue {
                self.messageTextView.frame = CGRect(x: 16, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 30)
                self.textBubbleView.frame = CGRect(x: 4, y: -4, width: estimatedFrame.width + 40, height: estimatedFrame.height + 26)
                bubbleImageView.isHidden = false

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
                messageTextView.frame = CGRect.zero
                textBubbleView.frame = CGRect(x: 4, y: -4, width: 300, height: 232)
                bubbleImageView.isHidden = false
                addMapView(CGRect(x: 16, y: 12, width: 272, height: 210))
            } else if message.actionType == ActionType.anchor.rawValue {
                self.messageTextView.frame = CGRect(x: 16, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 30)
                self.textBubbleView.frame = CGRect(x: 4, y: -4, width: estimatedFrame.width + 40, height: estimatedFrame.height + 32)
                bubbleImageView.isHidden = false
                let attributedString = NSMutableAttributedString(string: message.anchorData!.text)
                _ = attributedString.setAsLink(textToFind: message.anchorData!.text, linkURL: message.anchorData!.link, text: message.message)
                self.messageTextView.attributedText = attributedString
            } else {
                self.messageTextView.frame = .zero
                self.textBubbleView.frame = .zero
                self.bubbleImageView.frame = .zero
            }
        }

//        if message.responseType == MessageOld.ResponseTypes.map {
//            messageTextView.frame = CGRect(x: 16, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 30)
//            textBubbleView.frame = CGRect(x: 4, y: -4, width: estimatedFrame.width + 40, height: estimatedFrame.height + 240)
//            bubbleImageView.isHidden = false
//            addMapView(CGRect(x: 16, y: estimatedFrame.height + 20, width: estimatedFrame.width + 12, height: 210))
//        } else if message.responseType == MessageOld.ResponseTypes.websearch {
//            self.messageTextView.frame = CGRect(x: 16, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 30)
//            self.textBubbleView.frame = CGRect(x: 4, y: -4, width: estimatedFrame.width + 40, height: estimatedFrame.height + 85)
//            bubbleImageView.isHidden = false
//
//            let params = [
//                Client.WebsearchKeys.Query: message.query!,
//                Client.WebsearchKeys.Format: ControllerConstants.json
//            ]
//
//            Client.sharedInstance.websearch(params as [String : AnyObject], { (results, success, error) in
//                DispatchQueue.main.async {
//                    if success {
//                        self.message?.websearchData = results
//
//                        let frame = CGRect(x: 16, y: estimatedFrame.height + 20, width: estimatedFrame.width + 12, height: 52)
//                        self.addLinkPreview(frame)
//                    } else {
//                        debugPrint(error ?? ControllerConstants.errorOccured)
//                    }
//                    self.layoutIfNeeded()
//                }
//
//            })
//        } else if message.responseType == MessageOld.ResponseTypes.image {
//            let width = Int(frame.width / 2)
//            let height = 150
//            messageTextView.frame = CGRect(x: 16, y: 0, width: width + 16, height: height)
//            textBubbleView.frame = CGRect(x: 4, y: -4, width: width + 40, height: height)
//            bubbleImageView.isHidden = true
//
//            addImageView()
//        } else {
//            self.messageTextView.frame = CGRect(x: 16, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 30)
//            self.textBubbleView.frame = CGRect(x: 4, y: -4, width: estimatedFrame.width + 40, height: estimatedFrame.height + 26)
//            bubbleImageView.isHidden = false
//        }

    }

    func clearViews() {
        mapView.removeFromSuperview()
        websearchContentView.removeFromSuperview()
        imageView.removeFromSuperview()
    }

}
