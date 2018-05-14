//
//  MockedLocationManager.swift
//  DogWalk
//
//  Created by Masai Young on 5/14/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation
import CoreLocation

class MockLocationManager: LocationManager {
    
    var delegate: CLLocationManagerDelegate? = nil
    var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyKilometer
    var distanceFilter: CLLocationDistance = 10
    
    var whenInUseAuthRequestCount: Int = 0
    
    static func locationServicesEnabled() -> Bool {
        return true
    }
    
    static func authorizationStatus() -> CLAuthorizationStatus {
        if locationServicesEnabled() {
            return .denied
        } else {
            return .authorizedWhenInUse
        }
    }
    
    func requestWhenInUseAuthorization() {
        whenInUseAuthRequestCount += 1
    }
}
