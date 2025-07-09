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
