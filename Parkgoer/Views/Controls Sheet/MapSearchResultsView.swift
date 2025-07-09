//
//  MapSearchResultsView.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/9/25.
//

import SwiftUI
import MapKit

struct MapSearchResultsView: View {
    
    @Binding var mapCameraPosition: MapCameraPosition
    
    @Environment(MapSearchManager.self) private var mapSearchManager
    
    @ScaledMetric(relativeTo: .title3) private var symbolWidth = 48.0
    @Environment(\.dismissSearch) private var dismissSearch
    
    var body: some View {
        VStack {
            if mapSearchManager.locationResults.isEmpty {
                ContentUnavailableView.search(text: mapSearchManager.searchQuery)
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(mapSearchManager.locationResults, id: \.id) { location in
                            Button {
                                Task {
                                    mapSearchManager.searchQuery = ""
                                    guard let result = await mapSearchManager.performLocalSearch(for: location.1) else { return }
                                    
                                    withAnimation {
                                        mapCameraPosition = .region(MKCoordinateRegion(center: result.coordinate,
                                                                                       span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                                        
                                        hideKeyboard()
                                        mapSearchManager.detent = .height(200)
                                    }
                                }
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(location.1.title)
                                            .font(.headline)
                                        
                                        Text(location.1.subtitle)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .multilineTextAlignment(.leading)
                                .padding(.vertical)
                            }
                            .foregroundStyle(Color(uiColor: .label),
                                             Color(uiColor: .secondaryLabel))
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle(radius: 24))
                    }
                    .padding()
                }
                .scrollContentBackground(.hidden)
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
