//
//  ViewController.swift
//  DogWalk
//
//  Created by Masai Young on 5/11/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class MapViewModel {
    var locationService: LocationService
    
    init(locationService: LocationService) {
        self.locationService = locationService
    }
    
}

class MapViewController: UIViewController {
    var viewModel: MapViewModel
    var contentView = MapView()
    let bag = DisposeBag()
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(contentView)
        contentView.mapView.delegate = self
        setMapRegionAroundUserLocation()
    }
    
    func setMapRegionAroundUserLocation() {
        viewModel.locationService.userLocations
            .asDriver(onErrorJustReturn: CLLocation())
            .drive(onNext: { [weak self] location in
                self?.setMapRegion(around: location)
            })
            .disposed(by: bag)
    }
    
    func setMapRegion(around location: CLLocation) {
            let regionArea = 0.02 // smaller is more zoomed in
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: regionArea, longitudeDelta: regionArea))
            contentView.mapView.setRegion(region, animated: true)
    }

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return MKOverlayRenderer()
    }
}

