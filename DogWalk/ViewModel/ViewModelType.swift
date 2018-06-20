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
    var coordinates: PublishSubject<CLLocationCoordinate2D> { get }
}

protocol MapViewModelTypeOutputsType {
    var currentRoute: Driver<Mappable>! { get }
    var startButtonTapped: Driver<Void> { get }
    var stopButtonTapped: Driver<Void> { get }
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
    var coordinates: PublishSubject<CLLocationCoordinate2D>
    var regionArea = BehaviorSubject<Double>(value: 0.02)
    
    // MARK: - Outputs
    var startButtonTapped: Driver<Void>
    var stopButtonTapped: Driver<Void>
    var currentRoute: Driver<Mappable>!
    var isRecording: Driver<Bool>
    
    private var startButtonTappedObs: Observable<Void> {
        return startButtonTapped.asObservable()
    }
    
    private var stopButtonTappedObs: Observable<Void> {
        return stopButtonTapped.asObservable()
    }
    
    private var coordinates: Observable<CLLocationCoordinate2D> {
        
        Observable.create { observer in
            <#code#>
        }
        return locationService.currentCoordinate.asObservable()
    }
    
    private var mapMarkers: Observable<MarkerType> {
        return Observable
            .of(tiredButtonDidTap, bathroomButtonDidTap)
            .merge()
    }
    
    private var isRecordingObs: Observable<Bool> {
        return isRecording.asObservable()
    }
    
    // MARK: - Services
    var locationService: LocationProvider
    var routes = [UUID: Mappable]()
    
    // MARK: - Dispose
    let bag = DisposeBag()
    
    // MARK: - Private
    lazy var routeLocations: Observable<[CLLocationCoordinate2D]> = {
        return Observable
            .combineLatest(coordinates, isRecordingObs)
            .flatMapLatest({ (coords, isRecording) -> Observable<CLLocationCoordinate2D> in
                guard isRecording else { return .never() }
                return Observable.just(coords)
            })
            .scan([CLLocationCoordinate2D]()) { list, coord in
                print("Adding to list")
                return list + [coord]
        }
    }()
    
    lazy var routeMarkers: Observable<[MapMarker]> = {
        return mapMarkers
            .withLatestFrom(coordinates) { markerType, location in markerType.create(at: location)}
            .scan([MapMarker]()) { list, marker in
                return list + [marker]
            }
            .startWith([])
    }()
    
    // MARK: - Init
    init(services: MapViewModelServicesType) {
        // MARK: - Services
        self.locationService = services.locationService
        
        // MARK: - Outputs
        self.startButtonTapped = startButtonDidTap
            .asDriver(onErrorJustReturn: ())
            .throttle(0.3, latest: false)
        
        self.stopButtonTapped = stopButtonDidTap
            .asDriver(onErrorJustReturn: ())
            .throttle(0.3, latest: false)
        
        self.isRecording = Observable
            .of(startButtonTapped.map({_ in true}), stopButtonTapped.map({_ in false}))
            .merge()
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
        
        // MARK: - Private
        self.currentRoute = Observable
            .combineLatest(routeLocations, routeMarkers, isRecordingObs)
            .flatMapLatest({ (arg) -> Observable<([CLLocationCoordinate2D], [MapMarker], Bool)> in
                let (coords, markers, isRecording) = arg
                guard isRecording else { return .never() }
                return Observable
                    .combineLatest(Observable.just(coords),
                                   Observable.just(markers),
                                   Observable.just(isRecording))
            })
            .map({ (locations, markers, _) -> Mappable in
                print("routing")
                let route = Route(coordinates: locations, pins: markers)
                return route
            })
            .asDriver(onErrorJustReturn: Route()) as SharedSequence<DriverSharingStrategy, Mappable>

        
        startButtonDidTap
            .asObservable()
            .subscribe(onNext: {print("TAPPED")})
            .disposed(by: bag)
    }
    
}

class MapViewModelServices: MapViewModelServicesType {
    var locationService: LocationProvider
    
    init(locationService: LocationProvider) {
        self.locationService = locationService
    }
}

