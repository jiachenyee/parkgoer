//
//  Parking.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/7/25.
//

import Foundation
import CoreLocation
import SwiftData

@Model
final class Parking: Decodable, Identifiable, Equatable {
    
    var name: String
    
    var beautifiedName: String {
        var name = name.lowercased().replacingOccurrences(of: "_", with: " ")
        
        if name.split(separator: " ").last == "yb" {
            name.removeLast(2)
        }
        
        return name.capitalized
            .replacingOccurrences(of: " Yb ", with: " ")
            .replacingOccurrences(of: "Macpherson", with: "MacPherson")
            .replacingOccurrences(of: "Mrt", with: "MRT")
            .replacingOccurrences(of: "Ite", with: "ITE")
            .replacingOccurrences(of: " Cc", with: " CC")
    }
    
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var rackTypeString: String
    
    var filterAccepts: [MapFilterRegion.Filter] {
        var filters: [MapFilterRegion.Filter] = []
        
        filters.append(rackType.isYellowBox ? .yellowBox : .racks)
        filters.append(shelterIndicator ? .sheltered : .unsheltered)
        
        return filters
    }
    
    var rackType: RackType {
        get {
            RackType(from: rackTypeString)
        }
    }
    
    var rackCount: Int
    
    var qrCode: String?
    
    var shelterIndicator: Bool
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case latitude = "latitude"
        case longitude = "longitude"
        case rackType = "rackType"
        case rackCount = "rackCount"
        case shelterIndicator = "shelterIndicator"
        case qrCode = "qr"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.latitude = latitude
        self.longitude = longitude
        
        self.qrCode = try container.decodeIfPresent(String.self, forKey: .qrCode)
        
        self.rackTypeString = try container.decode(String.self, forKey: .rackType)
        self.rackCount = try container.decode(Int.self, forKey: .rackCount)
        let shelterIndicatorString = try container.decode(String.self, forKey: .shelterIndicator)
        self.shelterIndicator = shelterIndicatorString.lowercased() == "y"
    }
}

