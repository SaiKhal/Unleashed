//
//  Marker.swift
//  DogWalk
//
//  Created by Masai Young on 5/31/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation
import MapKit

protocol MapMarker: MKAnnotation {
    var title: String? { get set }
    var subtitle: String? { get set }
    var coordinate: CLLocationCoordinate2D { get set }
}

class ExhaustionMarker: NSObject, MapMarker {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(coord: CLLocationCoordinate2D) {
        self.coordinate = coord
    }
}

class BathroomMarker: NSObject, MapMarker {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(coord: CLLocationCoordinate2D) {
        self.coordinate = coord
    }
    
}

enum MarkerType: String {
    case exhaustion
    case bathroom
    
    func create(at coord: CLLocationCoordinate2D) -> MapMarker {
        switch self {
        case .exhaustion:
            return ExhaustionMarker(coord: coord)
        case .bathroom:
            return BathroomMarker(coord: coord)
        }
    }
    
    var color: UIColor {
        switch self {
        case .exhaustion:
            return .purple
        case .bathroom:
            return .cyan
        }
    }
}

