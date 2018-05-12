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
    var childCoordinators = [Coordinator]()
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if isLoggedIn {
            showMap()
        } else {
            showAuth()
        }
    }
    
    private func showAuth() {
        let coordinator = AuthCoordinator(with: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func showMap()  {
        let coordinator = MapVCCoordinator(with: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
}
