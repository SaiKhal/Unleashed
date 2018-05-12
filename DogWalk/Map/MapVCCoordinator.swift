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
    var childCoordinators = [Coordinator]()
    var mapViewController: MapViewController
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.mapViewController = MapViewController()
    }
    
    func start() {
        navigationController.pushViewController(mapViewController, animated: true)
    }
    
}
