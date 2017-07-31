//
//  LocationDelegate.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-07-19.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import CoreLocation

extension ChatViewController: CLLocationManagerDelegate {

    // Configures Location Manager
    func configureLocationManager() {
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined || CLLocationManager.authorizationStatus() == .denied {
            locationManager.requestWhenInUseAuthorization()
        }

        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

}
