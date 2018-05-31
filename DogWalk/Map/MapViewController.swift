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

protocol MapViewData {
    var locationService: LocationProvider { get set }
    var regionArea: Double { get set }
}

class MapViewModel: MapViewData {
    
    var locationService: LocationProvider
    var regionArea: Double
    
    init(locationService: LocationProvider) {
        self.locationService = locationService
        self.regionArea = 0.02 //my default value
    }
    
}

class MapViewController: UIViewController {
    var viewModel: MapViewData
    var contentView = MapView()
    let bag = DisposeBag()
    
    var pathLocations = [CLLocation]()
    
    var buttonPressed: Observable<Void> {
        return self.navigationItem.leftBarButtonItem!.rx.tap.asObservable()
    }
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(recordMovement))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: nil)
        
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
//        renderMovementPath()
    }
    
    @objc func testing() {
        buttonPressed.subscribe { tap in
            print("Button was tapped!")
        }
    }
    
    @objc func recordMovement() {
        print("Tracking Locations")
        
        /*
            This function starts tracking the user location and creates a map overlay for it.
            It no overlay exist, this function should create one.
            If overlay already exist, each new location should be added to the already created overlay.
         */
        
       viewModel.locationService.userLocations
        .takeUntil(buttonPressed)
        .asDriver(onErrorJustReturn: CLLocation())
        .drive(onNext: { [weak self] location in
            guard let strongSelf = self else { return }
            print(location, "AHHA")
            
            strongSelf.pathLocations.append(location)
            let coords = strongSelf.pathLocations.map({$0.coordinate})
            
            let polygon = MKPolygon(coordinates: coords, count: coords.count)
            strongSelf.contentView.mapView.add(polygon)
//            strongSelf.contentView.mapView.add(polyLine)

        })
        .disposed(by: bag)
    }
    
    func setMapRegionAroundUserLocation() {
        viewModel.locationService.userLocations
            .take(1)
            .asDriver(onErrorJustReturn: CLLocation())
            .drive(onNext: { [weak self] location in
                guard let strongSelf = self else { return }
                strongSelf.setMapRegion(around: location)
            })
            .disposed(by: bag)
    }
    
    func setMapRegion(around location: CLLocation) {
        let regionArea = viewModel.regionArea // smaller is more zoomed in
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: regionArea, longitudeDelta: regionArea))
        contentView.mapView.setRegion(region, animated: true)
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
        if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 1
            renderer.fillColor = .orange
            return renderer
        }
        
        return MKPolylineRenderer()
    }
}

