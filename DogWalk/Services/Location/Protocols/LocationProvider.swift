//
//  LocationProvider.swift
//  DogWalk
//
//  Created by Masai Young on 5/14/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

protocol LocationProvider {
    var locationManager: LocationManager { get }
    var userLocations: PublishSubject<CLLocation> { get }
    var currentCoordinate: Driver<CLLocationCoordinate2D> { get }
    
    init(manager: LocationManager)
    func checkForLocationServices()
}

protocol HasLocationProvider {
    var locationProvider: LocationProvider { get }
}
