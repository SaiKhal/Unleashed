//
//  AuthCoordinator.swift
//  DogWalk
//
//  Created by Masai Young on 5/11/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import UIKit

final class AuthCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var dependencies: Dependency
    var childCoordinators = [Coordinator]()
    
    init(rootNav navigationController: UINavigationController, dependency: Dependency) {
        self.navigationController = navigationController
        self.dependencies = dependency
    }
    
    func start()  {}
    
}
