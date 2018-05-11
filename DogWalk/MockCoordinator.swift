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
    var childCoordinators = [Coordinator]()
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() -> String {
        let nextCoordinator = MockCoordinator(with: navigationController)
//        let stringForTesting = nextCoordinator.start()
        childCoordinators.append(nextCoordinator)
        return "\(#function) returning"
    }
}
