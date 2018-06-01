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
    var tiredButtonDidTap: PublishSubject<Void> { get }
    var bathroomButtonDidTap: PublishSubject<Void> { get }
    var startButtonDidTap: PublishSubject<Void> { get }
    var stopButtonDidTap: PublishSubject<Void> { get }
}

protocol MapViewModelTypeOutputsType {
    var tiredButtonSelected: Driver<Void> { get }
    var bathroomButtonSelected: Driver<Void> { get }
    var startButtonSelected: Driver<Void> { get }
    var stopButtonSelected: Driver<Void> { get }
}

protocol MapViewModelServicesType {
    var locationService: LocationProvider { get }
}

typealias MapViewModelType = MapViewModelTypeOutputsType & MapViewModelTypeInputsType & MapViewModelServicesType

class MapViewModel2: MapViewModelType {
    // MARK: - Inputs
    var tiredButtonDidTap = PublishSubject<Void>()
    var bathroomButtonDidTap = PublishSubject<Void>()
    var startButtonDidTap = PublishSubject<Void>()
    var stopButtonDidTap = PublishSubject<Void>()
    var regionArea = BehaviorSubject<Double>(value: 0.02)
    
    // MARK: - Outputs
    var tiredButtonSelected: Driver<Void>
    var bathroomButtonSelected: Driver<Void>
    var startButtonSelected: Driver<Void>
    var stopButtonSelected: Driver<Void>
    
    // MARK: - Services
    var locationService: LocationProvider
    
    // MARK: - Dispose
    let bag = DisposeBag()
    
    // MARK: - Init
    init(services: MapViewModelServicesType) {
        self.locationService = services.locationService
        
        self.tiredButtonSelected = tiredButtonDidTap
            .asDriver(onErrorJustReturn: ())
            .throttle(0.3, latest: false)
        self.bathroomButtonSelected = bathroomButtonDidTap
            .asDriver(onErrorJustReturn: ())
            .throttle(0.3, latest: false)
        self.startButtonSelected = startButtonDidTap
            .asDriver(onErrorJustReturn: ())
            .throttle(0.3, latest: false)
        self.stopButtonSelected = stopButtonDidTap
            .asDriver(onErrorJustReturn: ())
            .throttle(0.3, latest: false)
    }
}

class MapViewModelServices: MapViewModelServicesType {
    var locationService: LocationProvider
    
    init(locationService: LocationProvider) {
        self.locationService = locationService
    }
}

