//
//  ParkingDetailView.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/7/25.
//

import SwiftUI
import MapKit

struct ParkingDetailView: View {
    
    var spot: Parking
    
    @Environment(LocationManager.self) private var locationManager
    
    var distance: Double? {
        if let coordinate = locationManager.coordinate {
            return coordinate - spot.coordinate
        } else {
            return nil
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let distance {
                    Text("\(Measurement<UnitLength>(value: distance, unit: .meters).formatted()) away")
                        .foregroundColor(.secondary)
                        .monospacedDigit()
                        .contentTransition(.numericText(value: distance))
                        .animation(.default, value: distance)
                        .frame(maxWidth: .infinity)
                        .padding(.top, -16)
                }
                
                ParkingSpotDataView(spot: spot)
                
                ParkingQRButton(distance: distance ?? 999, parking: spot)
                
                LookAroundView(coordinate: spot.coordinate)
                
//                Button {
//                    
//                } label: {
//                    Label("Plan Route", systemImage: "point.bottomleft.forward.to.point.topright.filled.scurvepath")
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                }
//                .buttonStyle(.borderedProminent)
//                .padding(.vertical)
                
                if let organization = spot.rackType.fullName {
                    Text("By \(organization).")
                        .foregroundColor(.secondary)
                        .padding(.top)
                }
            }
            .padding()
        }
        .scrollContentBackground(.hidden)
        .navigationTitle(spot.beautifiedName)
        .toolbar {
            ToolbarItem {
                OpenInMapsButton(parking: spot)
            }
        }
    }
}
