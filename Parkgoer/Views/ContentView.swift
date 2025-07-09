//
//  ContentView.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/3/25.
//

import SwiftUI
import MapKit
import SwiftData

struct ContentView: View {
    
    @AppStorage("showAllQR") private var showAllQR = false
    
    @Binding var mapFilterRegion: MapFilterRegion
    
    @State private var bicycleManager = BicycleFetchManager()
    @State private var locationManager = LocationManager()
    @State private var navigationManager = NavigationManager()
    @State private var mapSearchManager = MapSearchManager()
    
    @State private var selectedParking: Parking? = nil
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var parkingSpots: [Parking]
    
    @State private var mapCameraPosition = MapCameraPosition.userLocation(fallback: .automatic)
    
    init(mapFilterRegion: Binding<MapFilterRegion>) {
        self._mapFilterRegion = mapFilterRegion
        
        if mapFilterRegion.wrappedValue.region != nil {
            let minLongitude = mapFilterRegion.wrappedValue.minLongitude
            let maxLongitude = mapFilterRegion.wrappedValue.maxLongitude
            let minLatitude = mapFilterRegion.wrappedValue.minLatitude
            let maxLatitude = mapFilterRegion.wrappedValue.maxLatitude
            
            let minimumSpotsToDisplay = mapFilterRegion.wrappedValue.minimumSpotsToDisplay
            
            var descriptor = FetchDescriptor<Parking>(predicate: #Predicate {
                $0.rackCount >= minimumSpotsToDisplay &&
                $0.longitude >= minLongitude &&
                $0.longitude <= maxLongitude &&
                $0.latitude >= minLatitude &&
                $0.latitude <= maxLatitude
            }, sortBy: [SortDescriptor(\.rackCount, order: .reverse)])
            
            if mapFilterRegion.wrappedValue.loadFullData == true {
                descriptor.fetchLimit = 80
            } else {
                descriptor.fetchLimit = 50
            }
            
            _parkingSpots = Query(descriptor)
        } else {
            var descriptor = FetchDescriptor<Parking>()
            descriptor.fetchLimit = 1
            
            _parkingSpots = Query(descriptor)
        }
    }
    
    var body: some View {
        NavigationStack {
            ParkingMapView(selectedParking: $selectedParking,
                           mapCameraPosition: $mapCameraPosition,
                           mapFilterRegion: $mapFilterRegion,
                           parkingSpots: parkingSpots)
            .sheet(isPresented: .constant(true)) {
                SheetContentView(mapCameraPosition: $mapCameraPosition,
                                 selectedParking: $selectedParking,
                                 mapFilterRegion: $mapFilterRegion,
                                 showAllQR: $showAllQR,
                                 parkingSpots: parkingSpots)
            }
            .onAppear {
                bicycleManager.modelContext = modelContext
            }
            .modifier(ToolbarViewModifier(location: mapFilterRegion.region?.center))
            .task {
                bicycleManager.needsUpdate = await bicycleManager.checkForDatasetUpdate()
                if await bicycleManager.needsToAutoFetch() {
                    try? await bicycleManager.fetchParkingData()
                }
            }
        }
        .environment(locationManager)
        .environment(bicycleManager)
        .environment(mapSearchManager)
        .environment(navigationManager)
    }
    
    func shouldToolbarBeVisible() -> Bool {
        if #available(iOS 26.0, *) {
            return true
        } else {
            return false
        }
    }
}
