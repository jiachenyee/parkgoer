//
//  ParkingAndLocation.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/8/25.
//

import Foundation
import CoreLocation

struct ParkingAndDistance: Identifiable {
    var id: ObjectIdentifier {
        parking.id
    }
    
    let parking: Parking
    var distance: Double?
    
    init(parking: Parking, otherLocation: CLLocationCoordinate2D?) {
        self.parking = parking
        
        if let otherLocation {
            distance = otherLocation - parking.coordinate
        }
    }
    
    var distanceString: String? {
        if let distance {
            return Measurement<UnitLength>(value: distance, unit: .meters).formatted()
        } else {
            return nil
        }
    }
    
    var displaySubtitle: String {
        var dataToDisplay: [String] = []
        if parking.qrCode == nil { dataToDisplay.append("QR Code Unavailable") }
        if let distanceString { dataToDisplay.append("\(distanceString) away") }
        
        return dataToDisplay.joined(separator: " • ")
    }
}
