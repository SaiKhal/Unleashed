//
//  MapViewControllerCoordinator.swift
//  DogWalk
//
//  Created by Masai Young on 5/11/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import UIKit

final class MapVCCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var services: [ServiceTags : Service]
    var childCoordinators = [Coordinator]()
    var mapViewController: MapViewController
    
    init(rootNav navigationController: UINavigationController, services: [ServiceTags : Service]) {
        self.navigationController = navigationController
        self.services = services
        
        guard let locationService = services[ServiceTags.locationService] as? LocationProvider else {
            fatalError("MapVCCoordinator does not have location service neccessay to create MapViewModel")
        }
        
        let viewModel = MapViewModel(locationService: locationService)
        mapViewController = MapViewController(viewModel: viewModel)
    }
    
    func start() {
        navigationController.pushViewController(mapViewController, animated: true)
    }
    
}
