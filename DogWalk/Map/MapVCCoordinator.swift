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
    var dependencies: Dependency
    var childCoordinators = [Coordinator]()
    var mapViewController: MapViewController
    
    init(rootNav navigationController: UINavigationController, dependency: Dependency) {
        self.navigationController = navigationController
        self.dependencies = dependency
        
        let locationProvider = dependency.locationProvider
        let viewModel = MapViewModel(locationService: locationProvider)
        mapViewController = MapViewController(viewModel: viewModel)
        
        //mapViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(mapViewController.recordMovement))
    }
    
    func start() {
        navigationController.pushViewController(mapViewController, animated: true)
    }
    
}
