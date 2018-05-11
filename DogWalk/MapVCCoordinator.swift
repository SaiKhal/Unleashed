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
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() -> String {
        return "\(#function) returning"
    }
    
    
}
