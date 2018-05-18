//
//  MapViewControllerCoordinator.swift
//  DogWalk
//
//  Created by Masai Young on 5/11/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import UIKit

struct <#?#>APIClient {
    private init() {}
    static let manager = <#?#>APIClient()
    func get<#DataType#>(from urlStr: String, completionHandler: @escaping (<#Type#>) -> Void, errorHandler: (Error) -> Void) {
        guard let url = URL(string: urlStr) else {return}
        
        if let cachedImage = ImageCache.manager.getImage(urlStr: urlStr) {
            completionHandler(cachedImage)
            return
        }
        
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let <#variable#> = try JSONDecoder().decode(<#Type#>.self, from: data)
                completionHandler(<#variable#>)
            }
            catch {
                print(error)
            }
        }
        NetworkHelper.manager.performDataTask(with: URLRequest(url: url),
                                              completionHandler: completion,
                                              errorHandler: {print($0)})
    }
}
class NetworkHelper {
    private init() {
        urlSession.configuration.requestCachePolicy = .returnCacheDataElseLoad
    }
    static let manager = NetworkHelper()
    private let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    func performDataTask(with request: URLRequest, completionHandler: @escaping (Data) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            completionHandler(cachedResponse.data)
            return
        }
        
        self.urlSession.dataTask(with: request){(data: Data?, response: URLResponse?, error: Error?) in
            DispatchQueue.main.async {
                guard let data = data else {errorHandler(AppError.noData); return}
                if let error = error {
                    errorHandler(error)
                }
                completionHandler(data)
                
            }
            }.resume()
    }
}

final class MapVCCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var dependencies: Dependency
    var childCoordinators = [Coordinator]()
    var mapViewController: MapViewController
    
    init(rootNav navigationController: UINavigationController, dependency: Dependency) {
        self.navigationController = navigationController
        self.dependencies = dependency
        
        let locationProvider = dependency.locationProvider
        let viewModel = MapViewModel(locationService: locationProvider)
        mapViewController = MapViewController(viewModel: viewModel)
    }
    
//    init(rootNav navigationController: UINavigationController, services: [ServiceTags : Service]) {
//        self.navigationController = navigationController
//        self.services = services
//
//        guard let locationService = services[ServiceTags.locationService] as? LocationProvider else {
//            fatalError("MapVCCoordinator does not have location service neccessay to create MapViewModel")
//        }
//
//        let viewModel = MapViewModel(locationService: locationService)
//        mapViewController = MapViewController(viewModel: viewModel)
//    }
    
    func start() {
        navigationController.pushViewController(mapViewController, animated: true)
    }
    
}
