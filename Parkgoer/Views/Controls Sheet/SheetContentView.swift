//
//  SheetContentView.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/10/25.
//

import SwiftUI
import MapKit

struct SheetContentView: View {
    
    @Environment(MapSearchManager.self) private var mapSearchManager
    @Environment(BicycleFetchManager.self) private var bicycleManager
    @Environment(LocationManager.self) private var locationManager
    
    @Environment(NavigationManager.self) private var navigationManager
    
    @Binding var mapCameraPosition: MapCameraPosition
    @Binding var selectedParking: Parking?
    @Binding var mapFilterRegion: MapFilterRegion
    
    @Binding var showAllQR: Bool
    
    var parkingSpots: [Parking]
    
    var body: some View {
        @Bindable var mapSearchManager = mapSearchManager
        @Bindable var navigationManager = navigationManager

        NavigationStack {
            Group {
                if navigationManager.isRoutePresented {
                    VStack {
                        HStack {
                            if #available(iOS 26.0, *) {
                                VStack(spacing: 0) {
                                    Button {
                                        
                                    } label: {
                                        Text("Start of Route")
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                    }
                                    
                                    Divider()
                                    
                                    Button {
                                        
                                    } label: {
                                        Text("End Route")
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 32), isEnabled: true)
                            } else {
                                // Fallback on earlier versions
                            }
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "bicycle")
                                    .frame(width: 48, height: 48)
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.circle)
                        }
                        
                        Spacer()
                    }
                    .safeAreaPadding()
                } else {
                    if mapSearchManager.isSearching {
                        MapSearchResultsView(mapCameraPosition: $mapCameraPosition)
                    } else {
                        ParkingSpotsModalView(selectedParking: $selectedParking,
                                              mapFilterRegion: $mapFilterRegion,
                                              parking: parkingSpots,
                                              currentLocation: locationManager.coordinate)
                    }
                }
            }
            .searchable(text: $mapSearchManager.searchQuery)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarVisibility(.hidden, for: .navigationBar)
        }
        .presentationDetents([.height(200), .medium, .large], selection: $mapSearchManager.detent)
        .presentationBackgroundInteraction(.enabled)
        .interactiveDismissDisabled()
        .alert("Update Parking Data?", isPresented: $navigationManager.isReloadDataConfirmationPresented) {
            Button("Update Data") {
                Task {
                    try await bicycleManager.fetchParkingData()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This is an infrequent operation that fetches the latest parking data from the server. It may take a while to complete.")
        }
        .alert(showAllQR ? "Enable Location Check for QR Codes" :  "Disable Location Check for QR Codes", isPresented: $navigationManager.isShowAllQRAlertPresented) {
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
}
