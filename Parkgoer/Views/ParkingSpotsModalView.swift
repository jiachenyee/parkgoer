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
                            Button {
                                selectedParking = spot.parking
                            } label: {
                                HStack {
                                    Image(systemName: spot.parking.rackType.symbol)
                                        .font(.title3)
                                        .foregroundStyle(Color.accentColor)
                                        .frame(width: symbolWidth)
                                        .padding(.vertical, 4)
                                        .overlay {
                                            if spot.parking.rackType.isYellowBox {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.yellow, lineWidth: 2)
                                            }
                                        }
                                    
                                    VStack(alignment: .leading) {
                                        Text(spot.parking.beautifiedName)
                                            .font(.headline)
                                        
                                        Text(spot.displaySubtitle)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                        .padding(.trailing)
                                }
                                .multilineTextAlignment(.leading)
                                .padding(.vertical)
                            }
                            .foregroundStyle(Color(uiColor: .label),
                                             Color(uiColor: .secondaryLabel))
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle)
                    }
                    .padding(.horizontal)
                }
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle("What’s Around?")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $selectedParking) { spot in
            ParkingDetailView(spot: spot)
        }
    }
}
