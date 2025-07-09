//
//  Parking+Location.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/8/25.
//

import Foundation
import CoreLocation

extension Parking {
    struct Location: Codable {
        var latitude: Double
        var longitude: Double
        
        var coordinate: CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
}
