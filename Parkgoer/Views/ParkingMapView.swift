//
//  ParkingMapView.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/8/25.
//

import SwiftUI
import MapKit

struct ParkingMapView: View {
    
    @Binding var selectedParking: Parking?
    
    @Binding var mapCameraPosition: MapCameraPosition
    
    @Binding var mapFilterRegion: MapFilterRegion
    
    @Binding var isReloadDataConfirmationPresented: Bool
    
    @Binding var isShowAllQRAlertPresented: Bool
    
    var parkingSpots: [Parking]
    
    @Environment(BicycleFetchManager.self) var bicycleManager
    
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            Map(position: $mapCameraPosition, selection: $selectedParking, scope: namespace) {
                UserAnnotation()
                
                ForEach(parkingSpots) { spot in
                    Marker(spot.beautifiedName, systemImage: spot.rackType.symbol, coordinate: spot.coordinate)
                        .tint(.blue)
                        .tag(spot)
                }
            }
            .mapStyle(.standard(elevation: .automatic,
                                emphasis: .automatic,
                                pointsOfInterest: .excludingAll,
                                showsTraffic: false))
            .onMapCameraChange(frequency: .continuous) { context in
                withAnimation {
                    mapFilterRegion.region = context.region
                    mapFilterRegion.loadFullData = false
                }
            }
            .onMapCameraChange(frequency: .onEnd) { context in
                withAnimation {
                    mapFilterRegion.region = context.region
                    mapFilterRegion.loadFullData = true
                }
            }
            .mapControlVisibility(.visible)
            .mapControls {
                MapCompass()
                MapUserLocationButton()
            }
            
            if #unavailable(iOS 26.0) {
                VStack(alignment: .leading) {
                    if let location = mapFilterRegion.region?.center {
                        WeatherView(location: location, isShowAllQRAlertPresented: $isShowAllQRAlertPresented)
                            .frame(height: 48)
                            .background(.thickMaterial)
                            .clipShape(.rect(cornerRadius: 16, style: .continuous))
                    }
                    
                    Group {
                        if bicycleManager.isLoading {
                            ProgressView()
                                .frame(width: 48, height: 48)
                                .background(.thickMaterial)
                                .clipShape(.rect(cornerRadius: 16, style: .continuous))
                        } else {
                            Button {
                                isReloadDataConfirmationPresented = true
                            } label: {
                                Image(systemName: "arrow.clockwise")
                                    .frame(width: 48, height: 48)
                                    .background(.thickMaterial)
                                    .clipShape(.rect(cornerRadius: 16, style: .continuous))
                            }
                            .badge(bicycleManager.needsUpdate ? 1 : 0)
                        }
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .onChange(of: selectedParking) { oldValue, newValue in
            if let newValue {
                let coordinate: CLLocationCoordinate2D = [newValue.coordinate.latitude - 0.0003,
                                                          newValue.coordinate.longitude]
                
                withAnimation {
                    mapCameraPosition = .camera(MapCamera(centerCoordinate: coordinate,
                                                          distance: 500))
                }
            }
        }
    }
}
