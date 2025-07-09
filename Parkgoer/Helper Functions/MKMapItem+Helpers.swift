//
//  MKMapItem+Helpers.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/9/25.
//

import Foundation
import MapKit

extension MKMapItem {
    var coordinate: CLLocationCoordinate2D {
        if #available(iOS 26.0, *) {
            return self.location.coordinate
        } else {
            return self.placemark.coordinate
        }
    }
}
