//
//  AnswerMessageCell.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-21.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//
import UIKit
import Material
import MapKit
import Alamofire
import AlamofireImage

class ChatMessageCell: BaseCell, MKMapViewDelegate {
    
    var message: Message? {
        didSet {
            messageTextView.text = message?.body
            websiteText.text = message?.websearchData?.info
            
            if let imageString = message?.websearchData?.image {
                if let url = URL(string: imageString) {
                    let urlRequest = URLRequest(url: url)
                    searchImageView.af_setImage(withURLRequest: urlRequest)
                }
            }
            
            if let imageString = message?.body, imageString.isImage() {
                Alamofire.request(imageString).responseImage { response in
                    if let image = response.result.value {
                        print("image downloaded: \(image)")
                        self.imageView.image = image
                        self.imageView.startAnimating()
                    }
                }
            }
            
        }
    }
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = "Sample message"
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.isSelectable = false
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = false
        return mapView
    }()
    
    let websearchContentView = UIView()
    
    let searchImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "no-image")
        return imageView
    }()
    
    let websiteText: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.0)
        label.numberOfLines = 2
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8.0
        return imageView
    }()
    
    static let grayBubbleImage = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ChatMessageCell.grayBubbleImage
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        
        textBubbleView.addSubview(bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "H:|[v0]|", views: bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "V:|[v0]|", views: bubbleImageView)
        
    }
    
    func addMapView(_ frame: CGRect) {
        websearchContentView.removeFromSuperview()
        imageView.removeFromSuperview()
        textBubbleView.addSubview(mapView)
        
        mapView.frame = frame
        
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
        mapView.removeFromSuperview()
        imageView.removeFromSuperview()
        
        textBubbleView.addSubview(websearchContentView)
        websearchContentView.backgroundColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.0)
        websearchContentView.frame = frame
        
        websearchContentView.addSubview(searchImageView)
        websearchContentView.addSubview(websiteText)
        websearchContentView.addConstraintsWithFormat(format: "H:|-4-[v0(44)]-4-[v1]-4-|", views: searchImageView, websiteText)
        websearchContentView.addConstraintsWithFormat(format: "V:|-4-[v0]-4-|", views: searchImageView)
        websearchContentView.addConstraintsWithFormat(format: "V:|-4-[v0(44)]-4-|", views: websiteText)
    }
    
    func addImageView() {
        mapView.removeFromSuperview()
        websearchContentView.removeFromSuperview()
        messageTextView.text = ""
        textBubbleView.addSubview(imageView)
        textBubbleView.addConstraintsWithFormat(format: "H:|-20-[v0]-15-|", views: imageView)
        textBubbleView.addConstraintsWithFormat(format: "V:|-15-[v0]-15-|", views: imageView)
    }
    
}
