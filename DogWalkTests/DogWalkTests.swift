//
//  DogWalkTests.swift
//  DogWalkTests
//
//  Created by Masai Young on 5/11/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import DogWalk

class CoordinatorSpec: QuickSpec {
    override func spec() {
        describe("A Coordinator") {
            context("after being properly initialized") {
                let coordinator: Coordinator = AppCoordinator()
                
                it("should have navigation controller") {
                    expect(coordinator.navigationController).toNot(beNil())
                }
                
                it("should have any child coordinators") {
                    expect(coordinator.childCoordinators).toNot(beEmpty())
                }
                
            }
            
            context("when you call start") {
                it("should start the flow of a child coordinator") {
                    expect(coordinator.start).to(equal("starting child coordinator"))
                }
            }
        }
    }
}
