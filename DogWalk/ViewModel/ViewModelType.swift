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
    var isRecording: Driver<Bool> { get }
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
    var isRecording: Driver<Bool>
    
    private var startButtonSelectedObs: Observable<Void> {
        return startButtonSelected.asObservable()
    }
    
    private var stopButtonSelectedObs: Observable<Void> {
        return stopButtonSelected.asObservable()
    }
    
    private var coordinates: Observable<CLLocationCoordinate2D> {
        return locationService.currentCoordinate.asObservable()
    }
    
    // MARK: - Services
    var locationService: LocationProvider
    var routes = [UUID: Mappable]()
    
    // MARK: - Dispose
    let bag = DisposeBag()
    
    // MARK: - Private
    var routeLocations: Observable<[CLLocationCoordinate2D]>
    var routeMarkers: Observable<[MapMarker]>
    
    // MARK: - Init
    init(services: MapViewModelServicesType) {
        
        // MARK: - Services
        self.locationService = services.locationService
        
        // MARK: - Outputs
        self.startButtonSelected = startButtonDidTap
            .asDriver(onErrorJustReturn: ())
            .throttle(0.3, latest: false)
        
        self.stopButtonSelected = stopButtonDidTap
            .asDriver(onErrorJustReturn: ())
            .throttle(0.3, latest: false)
        
        self.isRecording = Observable
            .of(startButtonSelected.map({_ in true}), stopButtonSelected.map({_ in false}))
            .merge()
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
        
        // MARK: - Private
        routeLocations = Observable
            .combineLatest(self.locationService.currentCoordinate.asObservable(), isRecording.asObservable())
            .filter({_, isRecording in isRecording})
            .map({coord, _ in coord})
            .scan([CLLocationCoordinate2D]()) { list, coord in
                print("Adding to list")
                return list + [coord]
            }
            .startWith([])

        routeMarkers = Observable
            .of(self.tiredButtonDidTap, self.bathroomButtonDidTap)
            .merge()
            .withLatestFrom(self.locationService.currentCoordinate) { markerType, location in
                return markerType.create(at: location)
            }
            .scan([MapMarker]()) { list, marker in
                return list + [marker]
            }
            .startWith([])
        
        self.currentRoute = Observable.never()
            .asDriver(onErrorJustReturn: Route())
        
        // MARK: - Inputs
        self.startButtonDidTap
            .asObservable()
            .scan(0, accumulator: { acc, _ in acc + 1})
            .subscribe(onNext: { count in
                print("Count: ", count)
                self.resetRoute(coordinates: self.coordinates,
                      startButtonTapped: self.startButtonSelectedObs,
                      stopButtonTapped: self.startButtonSelectedObs,
                      mapInputs: [self.tiredButtonDidTap, self.bathroomButtonDidTap])
//                self.currentRoute = self.route(coordinates: self.coordinates,
//                                               startButtonTapped: self.startButtonSelectedObs,
//                                               stopButtonTapped: self.startButtonSelectedObs,
//                                               mapInputs: [self.tiredButtonDidTap, self.bathroomButtonDidTap])
                
                self.currentRoute.drive(onNext: { route in
                    print(route.coordinates.first)
                })
                
            })
            .disposed(by: bag)
        
        
        let _ = stopButtonSelected
            .withLatestFrom(currentRoute)
            .do(onNext: { route in
                let uuid = UUID()
                print("SAVING ROUTE with UUID: \(uuid.uuidString)")
                self.routes[uuid] = route
            })
    }
    
    func route(coordinates: Observable<CLLocationCoordinate2D>,
               startButtonTapped: Observable<Void>,
               stopButtonTapped: Observable<Void>,
               mapInputs: [PublishSubject<MarkerType>]) -> Driver<Mappable> {
        
        let routeLocations = Observable
            .combineLatest(coordinates, startButtonTapped)
            .map({coord, _ in coord})
            .scan([CLLocationCoordinate2D]()) { list, coord in
                print("Adding to list")
                return list + [coord]
        }
        
        let routeMarkers = Observable
            .from(mapInputs)
            .merge()
            .withLatestFrom(coordinates) { markerType, location in
                return markerType.create(at: location)
            }
            .scan([MapMarker]()) { list, marker in
                return list + [marker]
            }
            .startWith([])
        
        let route: Driver<Mappable> = Observable.combineLatest(routeLocations, routeMarkers)
            .map({ (locations, markers) in
                print("routing")
                let route = Route(coordinates: locations, pins: markers)
                return route
            })
            .takeUntil(stopButtonTapped)
            .asDriver(onErrorJustReturn: Route())
        
        return route
    }
    
    func resetRoute(coordinates: Observable<CLLocationCoordinate2D>,
                    startButtonTapped: Observable<Void>,
                    stopButtonTapped: Observable<Void>,
                    mapInputs: [PublishSubject<MarkerType>]) {
        
        self.routeLocations = Observable
            .combineLatest(coordinates, startButtonTapped)
            .map({coord, _ in coord})
            .scan([CLLocationCoordinate2D]()) { list, coord in
                print("Adding to list")
                return list + [coord]
        }
        
        self.routeMarkers = Observable
            .from(mapInputs)
            .merge()
            .withLatestFrom(coordinates) { markerType, location in
                return markerType.create(at: location)
            }
            .scan([MapMarker]()) { list, marker in
                return list + [marker]
            }
            .startWith([])
    }
    
    
}

class MapViewModelServices: MapViewModelServicesType {
    var locationService: LocationProvider
    
    init(locationService: LocationProvider) {
        self.locationService = locationService
    }
}

