//
//  Route.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/10/25.
//

import Foundation
import CoreLocation
import MapKit

struct Route {
    
    var intendedDurationBeforeStop: Double
    
    var intendedDistanceBeforeStop: Double {
        // assuming average speed of 10km/h
        intendedDurationBeforeStop / 3600 * 10
    }
    
    var subroutes: [Subroute]
    
    var distance: Double {
        subroutes.reduce(0) { $0 + $1.distance }
    }
    
    var duration: Double {
        subroutes.reduce(0) { $0 + $1.duration }
    }
    
    var formattedDuration: String {
        let hours = Int(duration / 3600)
        let minutes = Int((duration - Double(hours * 3600)) / 60)
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
        

    
    var advisoryNotices: [String] {
        Array(Set(subroutes.flatMap { $0.advisoryNotices }))
    }
    
    var coordinates: [CLLocationCoordinate2D] {
        subroutes.flatMap { $0.coordinates }
    }
    
    var firstStop: Parking {
        subroutes.first!.start
    }
    
    var lastStop: Parking {
        subroutes.last!.end
    }
    
    var allParkings: [Parking] {
        [subroutes.first!.start] + subroutes.map {
            $0.end
        }
    }
    
    struct Subroute: Identifiable {
        var id = UUID()
        
        var overshot: Bool?
        
        // in meters
        var distance: Double
        
        var advisoryNotices: [String]
        
        // assuming 10 km / h
        var duration: Double {
            distance / (10 / 3.6)
        }
        
        var coordinates: [CLLocationCoordinate2D]
        
        var start: Parking
        
        var end: Parking
        
        var subtitle: String {
            let minutes = Int(duration / 60)
            
            return Measurement<UnitLength>(value: distance,
                                           unit: .meters).formatted() + " • " + "\(minutes) min \(overshot == true ? "(over time)" : "")"
        }
    }
}
