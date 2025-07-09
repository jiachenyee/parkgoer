//
//  LocationManager.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/7/25.
//

import Foundation
import CoreLocation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    
    @ObservationIgnored
    private let locationManager = CLLocationManager()
    
    @ObservationIgnored
    var currentLocation: CLLocation? {
        locationManager.location
    }
    
    var coordinate: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        coordinate = newLocation.coordinate
    }
}
