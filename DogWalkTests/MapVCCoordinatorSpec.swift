//
//  MapViewControllerCoordinatorSpec.swift
//  DogWalkTests
//
//  Created by Masai Young on 5/11/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import DogWalk

class MapVCCoordinatorSpec: QuickSpec {
    override func spec() {
        describe("MapViewController Coordinator") {
            context("after being properly initialized") {
                let navController = UINavigationController()
                let coordinator: MapVCCoordinator = MapVCCoordinator(with: navController)
                
                it("should own a mapViewController") {
                    expect(coordinator.mapViewController).toNot(beNil())
                }
                
                context("when you call start") {
                    beforeEach {
                        coordinator.start()
                    }
                    
                    it("should show the mapViewController") {
                        expect(coordinator.navigationController.topViewController)
                            .to(beAKindOf(MapViewController.self))
                    }
                }
                
            }
        }
    }
}
