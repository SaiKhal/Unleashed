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
    var services: [ServiceTags : Service]
    var childCoordinators = [Coordinator]()
    
    init(rootNav navigationController: UINavigationController, services: [ServiceTags : Service]) {
        self.navigationController = navigationController
        self.services = services
    }
    
    func start()  {}
    
}
