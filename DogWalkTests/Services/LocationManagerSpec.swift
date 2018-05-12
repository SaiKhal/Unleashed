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

class MockLocationService: LocationProvider {
    
}

class LocationManagerSpec: QuickSpec {
    override func spec() {
        describe("LocationManager") {
            context("when properly initialized") {
                let locationManager = MockLocationService()
                
                it("should have a CLLocationManager property") {
                    expect(locationManager.manager).toNot(beNil())
                }
                
                it("should have a subject of CLLocation") {
                    expect(locationManager.userLocations).toNot(beNil())
                }
                
                it("should checkForLocationServices") {
                    expect().to(beAKindOf(MKMapViewDelegate.self))
                }
                
                context("and location services are enabled") {
                    it("should check for location auth status") {
                        
                    }
                    
                    
                }
                
            }
        }
    }
}
