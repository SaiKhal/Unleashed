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
    var locationService: LocationProvider
    
    init(locationService: LocationProvider) {
        self.locationService = locationService
    }
    
}

protocol TestProtocol {}

class MapViewController: UIViewController, TestProtocol {
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
        start()
    }
    
    func start() {
        setMapRegionAroundUserLocation()
        renderMovementPath()
    }
    
    func setMapRegionAroundUserLocation() {
        viewModel.locationService.userLocations
            .take(1)
            .asDriver(onErrorJustReturn: CLLocation())
            .drive(onNext: { [weak self] location in
                guard let strongSelf = self else { return }
                let pathLocations = strongSelf.create(coord: location.coordinate)
                let mkPolyLinePath = MKPolyline(coordinates: pathLocations, count: pathLocations.count)
                
                strongSelf.contentView.mapView.add(mkPolyLinePath)
            })
            .disposed(by: bag)
        
        let service = (viewModel.locationService as! LocationService)
//        service.locations
    }
    
    func renderMovementPath() {
        viewModel.locationService.userLocations
            .asDriver(onErrorJustReturn: CLLocation())
            .drive(onNext: { [weak self] location in
                guard let strongSelf = self else { return }
                
                let pathLocations = strongSelf.create(coord: location.coordinate)
                let mkPolyLinePath = MKPolyline(coordinates: pathLocations, count: pathLocations.count)
                
                strongSelf.contentView.mapView.add(mkPolyLinePath)
            })
            .disposed(by: bag)
    }
    
    func setMapRegion(around location: CLLocation) {
        let regionArea = 0.02 // smaller is more zoomed in
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: regionArea, longitudeDelta: regionArea))
        contentView.mapView.setRegion(region, animated: true)
    }
    
    typealias Coord = CLLocationCoordinate2D
    func create(coord: Coord) -> [Coord] {
        let path: [Coord] = (0...10)
            .map({ _ in coord })
            .enumerated()
            .map { tuple in
                var coord = tuple.element
                coord.latitude += Double(tuple.offset)*0.02
                return coord
        }
        
        print(path)
        return path
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .red
            renderer.lineWidth = 5
            return renderer
        }
        
        return MKPolylineRenderer()
    }
}

