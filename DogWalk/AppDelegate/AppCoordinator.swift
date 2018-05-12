//
//  AppCoordinator.swift
//  DogWalk
//
//  Created by Masai Young on 5/11/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import UIKit

protocol Service {}

enum ServiceTags {
    case locationService
}

final class AppCoordinator: Coordinator {
    
    var isLoggedIn: Bool = true
    var navigationController: UINavigationController
    var services: [ServiceTags: Service]
    
    var childCoordinators = [Coordinator]()
    
    
    init(rootNav navigationController: UINavigationController, services: [ServiceTags: Service]) {
        self.navigationController = navigationController
        self.services = services
        
        let locationService = LocationService()
        add(service: locationService, withTag: .locationService)
    }
    
    func start() {
        if isLoggedIn {
            showMap()
        } else {
            showAuth()
        }
    }
    
    private func showAuth() {
        let coordinator = AuthCoordinator(rootNav: navigationController, services: services)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    private func showMap()  {
        let coordinator = MapVCCoordinator(rootNav: navigationController, services: services)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
}
