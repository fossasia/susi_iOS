//
//  MapCell.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import MapKit

class MapCell: ChatMessageCell, MKMapViewDelegate {

    var message: Message? {
        didSet {
            addMapView()
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

    override func setupViews() {
        super.setupViews()
        setupCell()
    }

    func addMapView() {
        textBubbleView.addSubview(mapView)
        textBubbleView.addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: mapView)
        textBubbleView.addConstraintsWithFormat(format: "V:|-8-[v0]-8-|", views: mapView)

        mapView.frame = frame
        mapView.isZoomEnabled = false

        if let mapData = message?.mapData {
            let latitude = mapData.latitude
            let longitude = mapData.longitude

            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let zoomLevel = 360 / pow(2, Double(mapData.zoom - 1)) * Double(frame.width) / 256
            let span = MKCoordinateSpan.init(latitudeDelta: 0, longitudeDelta: zoomLevel)
            let region = MKCoordinateRegion(center: center, span: span)

            mapView.setRegion(region, animated: true)

            // add annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            mapView.addAnnotation(annotation)

            mapView.showsUserLocation = true
        }
    }

    func setupCell() {
        messageTextView.frame = CGRect.zero
        textBubbleView.frame = CGRect(x: 8, y: 0, width: 275, height: 198)
        textBubbleView.layer.borderWidth = 0.2
        textBubbleView.backgroundColor = .white
    }

}
