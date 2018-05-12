//
//  MapViewControllerSpec.swift
//  DogWalkTests
//
//  Created by Masai Young on 5/11/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Quick
import Nimble
import MapKit

@testable import DogWalk

class MapViewControllerSpec: QuickSpec {
    override func spec() {
        describe("MapViewController") {
            context("when properly initialized") {
                let mapViewController = MapViewController()
                _ = mapViewController.view //calls viewDidLoad
                
                it("should have a mapView") {
                    expect(mapViewController.contentView).toNot(beNil())
                }
                
                it("should conform to MKMapViewDelegate") {
                    expect(mapViewController).to(beAKindOf(MKMapViewDelegate.self))
                }
                
                it("should have its mapViews delegate set") {
                    expect(mapViewController.contentView.mapView.delegate).toNot(beNil())
                }
                
            }
        }
    }
}
