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
    
    @State private var isShowAllQRAlertPresented = false
    @AppStorage("showAllQR") private var showAllQR = false
    
    @Binding var mapFilterRegion: MapFilterRegion
    
    @State private var bicycleManager = BicycleFetchManager()
    
    @State private var locationManager = LocationManager()
    
    @State private var selectedParking: Parking? = nil
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var mapSearchManager = MapSearchManager()
    
    @Query private var parkingSpots: [Parking]
    
    @State private var isReloadDataConfirmationPresented = false
    
    init(mapFilterRegion: Binding<MapFilterRegion>) {
        self._mapFilterRegion = mapFilterRegion
        
        if mapFilterRegion.wrappedValue.region != nil {
            let minLongitude = mapFilterRegion.wrappedValue.minLongitude
            let maxLongitude = mapFilterRegion.wrappedValue.maxLongitude
            let minLatitude = mapFilterRegion.wrappedValue.minLatitude
            let maxLatitude = mapFilterRegion.wrappedValue.maxLatitude
            
            var descriptor = FetchDescriptor<Parking>(predicate: #Predicate {
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
    
    @State private var mapCameraPosition = MapCameraPosition.userLocation(fallback: .automatic)
    
    var body: some View {
        
        @Bindable var mapSearchManager = mapSearchManager
        
        NavigationStack {
            ParkingMapView(selectedParking: $selectedParking,
                           mapCameraPosition: $mapCameraPosition,
                           mapFilterRegion: $mapFilterRegion,
                           isReloadDataConfirmationPresented: $isReloadDataConfirmationPresented,
                           isShowAllQRAlertPresented: $isShowAllQRAlertPresented,
                           parkingSpots: parkingSpots)
            .sheet(isPresented: .constant(true)) {
                NavigationStack {
                    Group {
                        if mapSearchManager.isSearching {
                            MapSearchResultsView(mapCameraPosition: $mapCameraPosition)
                        } else {
                            ParkingSpotsModalView(selectedParking: $selectedParking,
                                                  mapFilterRegion: $mapFilterRegion,
                                                  parking: parkingSpots,
                                                  currentLocation: locationManager.coordinate)
                        }
                    }
                    .searchable(text: $mapSearchManager.searchQuery)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarVisibility(.hidden, for: .navigationBar)
                }
                .presentationDetents([.height(200), .medium, .large], selection: $mapSearchManager.detent)
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
                .alert("Update Parking Data?", isPresented: $isReloadDataConfirmationPresented) {
                    Button("Update Data") {
                        Task {
                            try await bicycleManager.fetchParkingData()
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("This is an infrequent operation that fetches the latest parking data from the server. It may take a while to complete.")
                }
                .alert(showAllQR ? "Enable Location Check for QR Codes" :  "Disable Location Check for QR Codes", isPresented: $isShowAllQRAlertPresented) {
                    Button(showAllQR ? "Enable" : "Disable", role: .destructive) {
                        showAllQR.toggle()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    if showAllQR {
                        Text("Enable the location check for QR codes? This will only allow you to view the QR code if you are within 100 m of it.")
                    } else {
                        Text("Disable the location check for QR codes? This will only allow you to view the QR codes outside of the 100 m range.")
                    }
                }
            }
            .onAppear {
                bicycleManager.modelContext = modelContext
            }
            .toolbar {
                if #available(iOS 26.0, *) {
                    ToolbarItem {
                        Group {
                            if bicycleManager.isLoading {
                                ProgressView()
                            } else {
                                Button("Reload", systemImage: "arrow.clockwise") {
                                    isReloadDataConfirmationPresented = true
                                }
                            }
                        }
                        .badge(bicycleManager.needsUpdate ? 1 : 0)
                    }
                    if let location = mapFilterRegion.region?.center {
                        ToolbarItem(placement: .topBarLeading) {
                            WeatherView(location: location, isShowAllQRAlertPresented: $isShowAllQRAlertPresented)
                        }
                    }
                }
            }
            .toolbarVisibility(shouldToolbarBeVisible() ? .visible : .hidden, for: .navigationBar)
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
    }
    
    func shouldToolbarBeVisible() -> Bool {
        if #available(iOS 26.0, *) {
            return true
        } else {
            return false
        }
    }
}
