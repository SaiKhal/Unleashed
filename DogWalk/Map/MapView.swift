//
//  MapView.swift
//  DogWalk
//
//  Created by Masai Young on 5/11/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class MapView: UIView {
    
    // MARK: - Properties
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.userTrackingMode = .follow
        return map
    }()
    
    lazy var userLocationButton: MKUserTrackingButton = {
        let userLocationButton = MKUserTrackingButton()
        userLocationButton.mapView = mapView
        return userLocationButton
    }()
    
    // MARK: - Inits
    init(viewController: UIViewController) {
        self.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        prepareViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup View/Data
    private func prepareViews() {
        prepareMap()
        prepareLocationButton()
    }
    
    private func prepareMap() {
        self.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(snp.edges)
        }
    }
    
    private func prepareLocationButton() {
        self.addSubview(userLocationButton)
        userLocationButton.snp.makeConstraints { make in
            make.left.equalTo(snp.left).offset(30)
            make.bottom.equalTo(snp.bottom).offset(-30)
        }
    }
    
}
