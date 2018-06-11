//
//  ViewModelType.swift
//  DogWalk
//
//  Created by Masai Young on 5/31/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

protocol MapViewModelTypeInputsType {
    var tiredButtonDidTap: PublishSubject<MarkerType> { get }
    var bathroomButtonDidTap: PublishSubject<MarkerType> { get }
    var startButtonDidTap: PublishSubject<Void> { get }
    var stopButtonDidTap: PublishSubject<Void> { get }
}

protocol MapViewModelTypeOutputsType {
    var currentRoute: Driver<Mappable> { get }
    var startButtonSelected: Driver<Void> { get }
    var stopButtonSelected: Driver<Void> { get }
}

protocol MapViewModelServicesType {
    var locationService: LocationProvider { get }
}

typealias MapViewModelType = MapViewModelTypeOutputsType & MapViewModelTypeInputsType & MapViewModelServicesType

class MapViewModel2: MapViewModelType {
    
    // MARK: - Inputs
    var tiredButtonDidTap = PublishSubject<MarkerType>()
    var bathroomButtonDidTap = PublishSubject<MarkerType>()
    var startButtonDidTap = PublishSubject<Void>()
    var stopButtonDidTap = PublishSubject<Void>()
    var regionArea = BehaviorSubject<Double>(value: 0.02)
    
    // MARK: - Outputs
    var startButtonSelected: Driver<Void>
    var stopButtonSelected: Driver<Void>
    var currentRoute: Driver<Mappable>
    
    // MARK: - Services
    var locationService: LocationProvider
    var routes = [UUID: Mappable]()
    
    // MARK: - Dispose
    let bag = DisposeBag()
    
    // MARK: - Init
    init(services: MapViewModelServicesType) {
        self.locationService = services.locationService
        
        self.startButtonSelected = startButtonDidTap
            .asDriver(onErrorJustReturn: ())
            .throttle(0.3, latest: false)
        
        self.stopButtonSelected = stopButtonDidTap
            .asDriver(onErrorJustReturn: ())
            .throttle(0.3, latest: false)
        
        let routeLocations = locationService.currentCoordinate
            .asObservable()
            .scan([CLLocationCoordinate2D]()) { list, coord in
                print("Adding to list")
                return list + [coord]
        }
        
        let routeMarkers = Observable
            .of(tiredButtonDidTap, bathroomButtonDidTap)
            .merge()
            .withLatestFrom(locationService.currentCoordinate) { markerType, location in
                return markerType.create(at: location)
            }
            .scan([MapMarker]()) { list, marker in
                return list + [marker]
            }
            .startWith([])
        
//        self.currentRoute = Observable.combineLatest(routeLocations, routeMarkers)
//            .map({ (locations, markers) in
//                let route = Route(coordinates: locations, pins: markers)
//                return route
//            })
//            .takeUntil(stopButtonSelected.asObservable())
//            .asDriver(onErrorJustReturn: Route())
        
        
        
        let _ = stopButtonSelected
            .withLatestFrom(currentRoute)
            .do(onNext: { route in
                let uuid = UUID()
                print("SAVING ROUTE with UUID: \(uuid.uuidString)")
                self.routes[uuid] = route
            })
        
        
    }
}

class MapViewModelServices: MapViewModelServicesType {
    var locationService: LocationProvider
    
    init(locationService: LocationProvider) {
        self.locationService = locationService
    }
}

