//
//  CLLocationCoordinate2D+Helpers.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/8/25.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    static func distance(between coordinate1: CLLocationCoordinate2D, and coordinate2: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        
        return location1.distance(from: location2)
    }
    
    static func - (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Double {
        distance(between: lhs, and: rhs)
    }
}

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension CLLocationCoordinate2D: @retroactive ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Double...) {
        guard elements.count == 2 else {
            fatalError("CLLocationCoordinate2D must be initialized with exactly two Double values.")
        }
        
        self.init(latitude: elements[0], longitude: elements[1])
    }
    
    public typealias ArrayLiteralElement = Double
}
