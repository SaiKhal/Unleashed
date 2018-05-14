//
//  LocationManager.swift
//  DogWalk
//
//  Created by Masai Young on 5/14/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManager: class {
    static func locationServicesEnabled() -> Bool
    static func authorizationStatus() -> CLAuthorizationStatus
    
    func requestWhenInUseAuthorization()
    
    var delegate: CLLocationManagerDelegate? { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    var distanceFilter: CLLocationDistance { get set }
}

extension CLLocationManager: LocationManager {}

