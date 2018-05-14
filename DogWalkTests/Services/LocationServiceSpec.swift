//
//  LocationManagerSpec.swift
//  DogWalk
//
//  Created by Masai Young on 5/12/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Quick
import Nimble
import CoreLocation


@testable import DogWalk

class LocationServiceSpec: QuickSpec {
    override func spec() {
        describe("LocationManager") {
            context("when properly initialized") {
                let mockDependency = MockDependency()
                let locationProvider = mockDependency.locationProvider as! MockLocationService
                let locationManager = locationProvider.locationManager as! MockLocationManager
                
                it("should have a CLLocationManager property") {
                    expect(locationProvider.locationManager).toNot(beNil())
                }
                
                it("should have a subject of CLLocation") {
                    expect(locationProvider.userLocations).toNot(beNil())
                }
                
                it("should checkForLocationServices") {
                    expect(locationProvider.locationServicesCheckedCount).to(be(0))
                    locationProvider.checkForLocationServices()
                    expect(locationProvider.locationServicesCheckedCount).to(be(1))
                }
                
                context("and location services are enabled") {
                    it("should check for location auth status") {
                        let unauthorizedStatuses: [CLAuthorizationStatus] = [.denied, .notDetermined]
                        let currentAuthStatus: CLAuthorizationStatus = MockLocationManager.authorizationStatus()
                        expect(unauthorizedStatuses).to(containElementSatisfying({$0 == currentAuthStatus}))
                    }
                    
                    it("should request whenInUseAuth") {
                        expect(locationManager.whenInUseAuthRequestCount).to(be(0))
                        locationManager.requestWhenInUseAuthorization()
                        expect(locationManager.whenInUseAuthRequestCount).to(be(1))
                    }
                    
                    
                }
                
            }
        }
    }
}
