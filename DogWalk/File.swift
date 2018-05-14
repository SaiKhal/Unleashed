//
//  File.swift
//  DogWalk
//
//  Created by Masai Young on 5/14/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation

typealias Dependency = HasLocationProvider
struct AppDependecy: Dependency {
    var locationProvider: LocationProvider
}

extension AppDependecy {
    init(location: LocationProvider = LocationService()) {
        self.locationProvider = location
    }
}

protocol HasLocationProvider {
    var locationProvider: LocationProvider { get set }
}

struct MockDependency: Dependency {
    var locationProvider: LocationProvider = MockLocationService(manager: MockLocationManager())
}
