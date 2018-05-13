//
//  LocationManager.swift
//  DogWalk
//
//  Created by Masai Young on 5/11/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import RxSwift
import RxCocoa

protocol LocationManagerType: class {
    static func locationServicesEnabled() -> Bool
    static func authorizationStatus() -> CLAuthorizationStatus
}

extension CLLocationManager: LocationManagerType {}

protocol LocationProvider: Service {
    var locationManager: LocationManagerType { get set }
    var userLocations: PublishSubject<CLLocation> { get set }
    
    init(manager: LocationManagerType)
    func checkForLocationServices()
}

class MockLocationService: LocationProvider {
    var locationManager: LocationManagerType
    var userLocations = PublishSubject<CLLocation>()
    
    required init(manager: LocationManagerType) {
        self.locationManager = manager
    }
    
    
    var locationServicesChecked = false
    
    func checkForLocationServices() {
        locationServicesChecked = true
    }
}

class MockedLocationManagerType: LocationManagerType {
    static func locationServicesEnabled() -> Bool {
        return true
    }
    
    static func authorizationStatus() -> CLAuthorizationStatus {
        if locationServicesEnabled() {
            return .authorizedWhenInUse
        } else {
            return .denied
        }
    }
}

class LocationService: NSObject, LocationProvider {
    
    // MARK: - Properties
    // Apple suggest to only have one instance of CLLocationManager
    var locationManager: LocationManagerType
    var userLocations = PublishSubject<CLLocation>()
    
    var manager: CLLocationManager {
        return locationManager as! CLLocationManager
    }

    // MARK: - Inits
    required init(manager: LocationManagerType = CLLocationManager()) {
        guard let manager = manager as? CLLocationManager else {
            fatalError("Must be initialized with CLLocationManager() the default init, protocol param is for mocking")
        }
        
        locationManager = manager
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.distanceFilter = 10
        checkForLocationServices()
    }
    
    func lookUpAddress(location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void) {
        // Use the last reported location.
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location,
                                        completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                let firstLocation = placemarks?[0]
                                                completionHandler(firstLocation)
                                            }
                                            else {
                                                // An error occurred during geocoding.
                                                completionHandler(nil)
                                            }
        })
    }
    
    // MARK: - Private Methods
    func checkForLocationServices() {
        let phoneLocationServicesAreEnabled = CLLocationManager.locationServicesEnabled()
        if phoneLocationServicesAreEnabled {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined: // intial state on first launch
                print("not determined")
                manager.requestWhenInUseAuthorization()
            case .denied: // user could potentially deny access
                print("denied")
                manager.requestWhenInUseAuthorization()
            case .authorizedAlways:
                print("authorizedAlways")
            case .authorizedWhenInUse:
                print("authorizedWhenInUse")
            default:
                break
            }
        }
    }
    
}

// MARK: - CLLocationManagerDelegate Methods
extension LocationService: CLLocationManagerDelegate {
    // This method is called once when app loads, responsible for `startUpdatingLocation`
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
            print("Location updating")
        default:
            manager.stopUpdatingLocation()
            print("Location stopped updating")
        }
    }
    
    // Handles user location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return }
//        locationServiceDelegate.userLocationDidUpdate(userLocation)
        userLocations.onNext(userLocation)
        print("Updated locations: \(locations)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    
}

