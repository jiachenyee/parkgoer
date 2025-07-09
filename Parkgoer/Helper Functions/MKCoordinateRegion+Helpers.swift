//
//  MKCoordinateRegion+Helpers.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/8/25.
//

import Foundation
import MapKit

extension MKCoordinateRegion {
    var maxLongitude: CLLocationDegrees {
        center.longitude + span.longitudeDelta / 2
    }
    
    var minLongitude: CLLocationDegrees {
        center.longitude - span.longitudeDelta / 2
    }
    
    var maxLatitude: CLLocationDegrees {
        center.latitude + span.latitudeDelta / 2
    }
    
    var minLatitude: CLLocationDegrees {
        center.latitude - span.latitudeDelta / 2
    }
    
    func contains(_ otherPoint: CLLocationCoordinate2D) -> Bool {
        return otherPoint.longitude >= minLongitude &&
        otherPoint.longitude <= maxLongitude &&
        otherPoint.latitude >= minLatitude &&
        otherPoint.latitude <= maxLatitude
    }
}
