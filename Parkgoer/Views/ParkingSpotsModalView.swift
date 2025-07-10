//
//  ParkingSpotsModalView.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/8/25.
//

import SwiftUI
import CoreLocation

struct ParkingSpotsModalView: View {
    
    @Binding var selectedParking: Parking?
    @Binding var mapFilterRegion: MapFilterRegion
    
    var parkingSpots: [ParkingAndDistance]
    
    init(selectedParking: Binding<Parking?>,
         mapFilterRegion: Binding<MapFilterRegion>,
         parking: [Parking],
         currentLocation: CLLocationCoordinate2D?) {
        self._selectedParking = selectedParking
        self._mapFilterRegion = mapFilterRegion
        
        self.parkingSpots = parking.map {
            ParkingAndDistance(parking: $0, otherLocation: currentLocation)
        }.sorted {
            ($0.distance ?? .greatestFiniteMagnitude) < ($1.distance ?? .greatestFiniteMagnitude)
        }
    }
    
    @ScaledMetric(relativeTo: .title3) private var symbolWidth = 48.0
    
    var body: some View {
        VStack {
            if parkingSpots.isEmpty {
                ContentUnavailableView("No Parking Spots Nearby",
                                       systemImage: "bicycle",
                                       description: Text("Look in a different area of the map to find parking spots."))
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(parkingSpots) { spot in
                            ParkingSpotRowView(action: {
                                selectedParking = spot.parking
                            }, spot: spot)
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle(radius: 24))
                    }
                    .padding()
                }
                .scrollContentBackground(.hidden)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
