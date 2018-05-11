//
//  AppCoordinatorSpec.swift
//  DogWalkTests
//
//  Created by Masai Young on 5/11/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import DogWalk

class AppCoordinatorSpec: QuickSpec {
    override func spec() {
        describe("App Coordinator") {
            context("after being properly initialized") {
                let navController = UINavigationController()
                let coordinator: AppCoordinator = AppCoordinator(with: navController)
                
                it("should know if the user is logged in") {
                    expect(coordinator.isLoggedIn).to(beFalse())
                }
                
                context("when you call start") {
                    context("if logged in") {
                        beforeEach {
                            coordinator.isLoggedIn = true
                        }
                        it("should start map flow") {
                            expect(coordinator.start()).to(equal("showMap() returning"))
                            expect(coordinator.childCoordinators).toNot(beEmpty())
                            expect(coordinator.childCoordinators).to(containElementSatisfying({ (coord) -> Bool in
                                return coord is MapViewControllerCoordinator
                            }))
                        }
                    }
                    
                    context("if not logged in") {
                        beforeEach {
                            coordinator.isLoggedIn = false
                        }
                        it("should start authentification flow") {
                            expect(coordinator.start()).to(equal("showAuth() returning"))
                            expect(coordinator.childCoordinators).toNot(beEmpty())
                            expect(coordinator.childCoordinators).to(containElementSatisfying({ (coord) -> Bool in
                                return coord is AuthCoordinator
                            }))
                        }
                    }
                }
                
            }
        }
    }
}
