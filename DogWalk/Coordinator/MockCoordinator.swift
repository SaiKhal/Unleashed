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
    var services: [ServiceTags : Service]
    var childCoordinators = [Coordinator]()
    
    init(rootNav navigationController: UINavigationController, services: [ServiceTags : Service]) {
        self.navigationController = navigationController
        self.services = services
    }
    
    func start() {
        let nextCoordinator = MockCoordinator(rootNav: navigationController, services: services)
//        let stringForTesting = nextCoordinator.start()
        addChildCoordinator(nextCoordinator)
    }
}
