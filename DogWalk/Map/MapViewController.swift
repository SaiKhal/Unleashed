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
import RxMKMapView

class MapViewController: UIViewController {
    // MARK: - Views
    var contentView = MapView()
    let startButton = UIBarButtonItem(barButtonSystemItem: .play, target: nil, action: nil)
    let stopButton = UIBarButtonItem(barButtonSystemItem: .pause, target: nil, action: nil)
    let tiredButton = UIBarButtonItem(barButtonSystemItem: .redo, target: nil, action: nil)
    let bathroomButton = UIBarButtonItem(barButtonSystemItem: .trash, target: nil, action: nil)
    
    // MARK: - Properties
    var viewModel: MapViewModelType
    let bag = DisposeBag()
    
    // MARK: - Inits
    init(viewModel: MapViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        navigationItem.rightBarButtonItems = [startButton, stopButton]
        navigationItem.leftBarButtonItems = [tiredButton, bathroomButton]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(contentView)
        contentView.mapView.delegate = self
        start()
    }
    
    func start() {
        setMapRegionAroundUserLocation()
        bind(to: viewModel)
    }
    
    // MARK: - Bindings
    func bind(to viewModel: MapViewModelType) {
        
        // View Model Inputs
        startButton.rx.tap
            .debug("start tapped")
            .bind(to: viewModel.startButtonDidTap)
            .disposed(by: bag)
        
        stopButton.rx.tap
            .debug("stop tapped")
            .bind(to: viewModel.stopButtonDidTap)
            .disposed(by: bag)
        
        bathroomButton.rx.tap
            .debug("bathroom tapped")
            .map({MarkerType.bathroom})
            .bind(to: viewModel.bathroomButtonDidTap)
            .disposed(by: bag)
        
        tiredButton.rx.tap
            .debug("tired tapped")
            .map({MarkerType.exhaustion})
            .bind(to: viewModel.tiredButtonDidTap)
            .disposed(by: bag)
        
        // View Model Outputs
        viewModel.startButtonSelected
            .drive(onNext: renderRoute)
            .disposed(by: bag)
        
        viewModel.stopButtonSelected
            .drive(onNext: saveRoute)
            .disposed(by: bag)
    }
    
    // MARK: - ViewModel Outlet Methods
    private func saveRoute() {
        removeMapOverlays()
        removeMapAnnotations()
    }
    
    private func renderRoute() {
        viewModel.currentRoute
            .drive(onNext: { route in
            let coords = route.coordinates
            let polygon = MKPolygon(coordinates: coords, count: coords.count)
            self.contentView.mapView.removeOverlays(self.contentView.mapView.overlays)
                
            self.contentView.mapView.add(polygon)
            self.contentView.mapView.addAnnotations(route.pins)
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
                let regionArea = 0.02 // smaller is more zoomed in
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: regionArea, longitudeDelta: regionArea))
                contentView.mapView.setRegion(region, animated: true)
    }
    
}

extension MapViewController {
    func removeMapAnnotations() {
        let allAnnotations = self.contentView.mapView.annotations
        self.contentView.mapView.removeAnnotations(allAnnotations)
    }
    
    func removeMapOverlays() {
        let allOverlays = self.contentView.mapView.overlays
        self.contentView.mapView.removeOverlays(allOverlays)
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view: MKMarkerAnnotationView
        
        switch annotation {
        case is ExhaustionMarker:
            let markerType: MarkerType = .exhaustion
            view = contentView.mapView.dequeReusableMarkerView(annotation: annotation, type: markerType)
            view.markerTintColor = markerType.color
        default:
            return nil
        }
        
        return view
    }
    
    
}

extension MKMapView {
    func dequeReusableMarkerView(annotation: MKAnnotation, type: MarkerType) -> MKMarkerAnnotationView {
        let view: MKMarkerAnnotationView
        if let dequeuedView = self.dequeueReusableAnnotationView(withIdentifier: type.rawValue)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: type.rawValue)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return view
    }
}
