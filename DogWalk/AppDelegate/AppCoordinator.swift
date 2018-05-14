//
//  AppCoordinator.swift
//  DogWalk
//
//  Created by Masai Young on 5/11/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var isLoggedIn: Bool = true
    var navigationController: UINavigationController
    var dependencies: Dependency
    var childCoordinators = [Coordinator]()
    
    init(rootNav navigationController: UINavigationController, dependency: Dependency) {
        self.navigationController = navigationController
        self.dependencies = dependency
    }
    
    func start() {
        if isLoggedIn {
            showMap()
        } else {
            showAuth()
        }
    }
    
    private func showAuth() {
        let coordinator = AuthCoordinator(rootNav: navigationController, dependency: dependencies)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    private func showMap()  {
        let coordinator = MapVCCoordinator(rootNav: navigationController, dependency: dependencies)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
}
