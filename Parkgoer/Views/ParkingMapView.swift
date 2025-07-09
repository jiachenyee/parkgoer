//
//  ParkingMapView.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/8/25.
//

import SwiftUI
import MapKit

struct ParkingMapView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    
    @Binding var selectedParking: Parking?
    
    @Binding var mapCameraPosition: MapCameraPosition
    
    @Binding var mapFilterRegion: MapFilterRegion
        
    var parkingSpots: [Parking]
    
    @Environment(BicycleFetchManager.self) var bicycleManager
    
    @Namespace var namespace
    
    @State private var isFollowingUserLocation: Bool = false
    
    var body: some View {
        @Bindable var navigationManager = navigationManager
        
        ZStack {
            Map(position: $mapCameraPosition,
                interactionModes: [.pan, .rotate, .zoom],
                selection: $selectedParking,
                scope: namespace) {
                
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
                    isFollowingUserLocation = mapCameraPosition.followsUserLocation
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
            
            if isFollowingUserLocation {
                Circle()
                    .trim(from: 0.08, to: 0.92)
                    .stroke(lineWidth: 2)
                    .rotationEffect(.degrees(-90))
                    .overlay(alignment: .top) {
                        HStack {
                            Image(systemName: "bicycle")
                            Text(mapFilterRegion.cyclingEstimateOutput)
                                .monospacedDigit()
                                .contentTransition(.numericText())
                        }
                        .font(.system(size: 16, weight: .medium))
                    }
                    .padding()
                    .shadow(color: Color(uiColor: .systemBackground), radius: 4, x: 0, y: 0)
                    .shadow(color: Color(uiColor: .systemBackground), radius: 4, x: 0, y: 0)
                    .allowsHitTesting(false)
                    .sensoryFeedback(.selection, trigger: mapFilterRegion.cycleHapticTrigger)
            }
            
            LegacyControlsLayerView(mapFilterRegion: mapFilterRegion,
                                    isReloadDataConfirmationPresented: $navigationManager.isReloadDataConfirmationPresented,
                                    isShowAllQRAlertPresented: $navigationManager.isShowAllQRAlertPresented)
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
