//
//  MapFilterRegion.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/8/25.
//

import Foundation
import SwiftUI
import MapKit

struct MapFilterRegion {
    var region: MKCoordinateRegion?
    var loadFullData: Bool
    var filter: Filter = .all
    
    var minLongitude: Double {
        region?.minLongitude ?? 0
    }
    var maxLongitude: Double {
        region?.maxLongitude ?? 0
    }
    var minLatitude: Double {
        region?.minLatitude ?? 0
    }
    var maxLatitude: Double {
        region?.maxLatitude ?? 0
    }
    
    // in meters
    var span: Double {
        guard let region = region else { return 0 }
        
        let min: CLLocationCoordinate2D = [region.center.latitude, minLongitude]
        let max: CLLocationCoordinate2D = [region.center.latitude, maxLongitude]
        
        return min - max
    }
    
    var minimumSpotsToDisplay: Int {
        if span < 500 {
            return 0
        } else {
            let scaledValue = Int(span / 500) * 5
            return min(max(1, scaledValue), 180)
        }
    }
    
    // assuming 10 km/h cycling speed
    var secondsToCycle: Double {
        guard span > 0 else { return 0 }
        
        let speedInMetersPerSecond: Double = 10 * 1000 / 3600 // 10 km/h in m/s
        let timeInSeconds = span / speedInMetersPerSecond
        
        return timeInSeconds
    }
    
    var cycleHapticTrigger: String {
        let minutes = Int(round(secondsToCycle)) / 60
        let everyFiveMinutes = minutes / 5
        let hours = minutes / 60
        
        if hours >= 1 {
            return "\(hours)h"
        } else if minutes >= 10 {
            return "\(everyFiveMinutes)fm"
        } else {
            return "\(minutes)m"
        }
    }
    
    var cyclingEstimateOutput: String {
        let minutes = Int(round(secondsToCycle)) / 60
        let hours = minutes / 60
        
        let minutesAndHours = (hours > 0) ? "\(hours)h \(minutes % 60)m" : "\(minutes) min"
        
        return "\(minutesAndHours) • \(Measurement<UnitLength>(value: span, unit: .meters).formatted())"
    }
    
    enum Filter: String, CaseIterable {
        case all
        case yellowBox
        case racks
        case sheltered
        case unsheltered
        
        var name: String {
            switch self {
            case .all: return "All"
            case .yellowBox: return "Yellow Boxes"
            case .racks: return "Racks"
            case .sheltered: return "Sheltered"
            case .unsheltered: return "Unsheltered"
            }
        }
        
        var systemImage: String {
            switch self {
            case .all: return "bicycle"
            case .yellowBox: return "rectangle"
            case .racks: return "rectangle.split.3x1"
            case .sheltered: return "umbrella"
            case .unsheltered: return "cloud.rain"
            }
        }
        
        var color: Color {
            switch self {
            case .all: Color.blue
            case .yellowBox: Color.yellow
            case .racks: Color.mint
            case .sheltered: Color.indigo
            case .unsheltered: Color.gray
            }
        }
    }
}
