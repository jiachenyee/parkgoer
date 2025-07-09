//
//  OpenInMapsButton.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/8/25.
//

import SwiftUI

struct OpenInMapsButton: View {
    
    var parking: Parking
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        Button("Open in Maps", systemImage: "map") {
            openURL(URL(string: "https://maps.apple.com/place?map=explore&coordinate=\(parking.latitude),\(parking.longitude)&name=\(parking.rackType.isYellowBox ? "Yellow+Box" : "Bike+Rack"):+\(parking.beautifiedName)")!)
        }
    }
}
