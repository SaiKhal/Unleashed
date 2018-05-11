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
                
                it("should know if the user is logged in") {
                    expect(coordinator.mapViewController).to(beTruthy())
                }
                
                context("when you call start") {
                    expect(coordinator.navigationController.topViewController).to(equal(MapViewController))
                }
                
            }
        }
    }
}
