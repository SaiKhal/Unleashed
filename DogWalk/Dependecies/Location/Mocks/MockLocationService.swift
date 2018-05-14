//
//  MockLocationService.swift
//  DogWalk
//
//  Created by Masai Young on 5/14/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

class MockLocationService: LocationProvider {
    var locationManager: LocationManager
    var userLocations = PublishSubject<CLLocation>()
    
    required init(manager: LocationManager) {
        self.locationManager = manager
    }
    
    var locationServicesCheckedCount = 0
    
    func checkForLocationServices() {
        locationServicesCheckedCount += 1
    }
}
