//
//  AppCoordinator.swift
//  DogWalk
//
//  Created by Masai Young on 5/11/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import UIKit

final class MockCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var dependencies: Dependency
    var childCoordinators = [Coordinator]()
    
    init(rootNav navigationController: UINavigationController, dependency: Dependency) {
        self.navigationController = navigationController
        self.dependencies = dependency
    }
    
    func start() {
        let nextCoordinator = MockCoordinator(rootNav: navigationController, dependency: dependencies)
//        let stringForTesting = nextCoordinator.start()
        addChildCoordinator(nextCoordinator)
    }
}
