//
//  LocationManagerSpec.swift
//  DogWalk
//
//  Created by Masai Young on 5/12/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Quick
import Nimble


@testable import DogWalk

class LocationServiceSpec: QuickSpec {
    override func spec() {
        describe("LocationManager") {
            context("when properly initialized") {
                let mockManagerType = MockedLocationManagerType()
                let locationManager = MockLocationService(manager: mockManagerType)
                
                it("should have a CLLocationManager property") {
                    expect(locationManager).toNot(beNil())
                }
                
                it("should have a subject of CLLocation") {
                    expect(locationManager.userLocations).toNot(beNil())
                }
                
                it("should checkForLocationServices") {
                    expect(locationManager.locationServicesChecked).to(beFalse())
                    locationManager.checkForLocationServices()
                    expect(locationManager.locationServicesChecked).to(beTrue())
                }
                
                context("and location services are enabled") {
                    it("should check for location auth status") {
                        
                    }
                    
                    
                }
                
            }
        }
    }
}
