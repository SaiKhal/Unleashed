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
    
    func start() -> String {
        if isLoggedIn {
            return showMap()
        } else {
            return showAuth()
        }
    }
    
    private func showAuth() -> String {
        let coordinator = AuthCoordinator(with: navigationController)
        childCoordinators.append(coordinator)
        return "\(#function) returning"
    }
    
    private func showMap() -> String {
        let coordinator = MapViewControllerCoordinator(with: navigationController)
        childCoordinators.append(coordinator)
        return "\(#function) returning"
    }
    
}
