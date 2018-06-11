//
//  Route.swift
//  DogWalk
//
//  Created by Masai Young on 5/31/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation
import CoreLocation

protocol Mappable {
    var coordinates: [CLLocationCoordinate2D] { get set }
    var pins: [MapMarker] { get set }
}

struct Route: Mappable {
    var coordinates = [CLLocationCoordinate2D]()
    var pins = [MapMarker]()
}

enum RouteData {
    case coord([CLLocationCoordinate2D])
    case pins(MapMarker)
    case error(String)
}
