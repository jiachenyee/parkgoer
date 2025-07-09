//
//  MapSearchManager.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/9/25.
//

import Foundation
import Observation
import MapKit
import SwiftUI

@Observable
class MapSearchManager: NSObject, MKLocalSearchCompleterDelegate {
    
    @ObservationIgnored
    let completer = MKLocalSearchCompleter()
    
    private var locationSearchTask: Task<Void, Never>?
    
    var locationResults: [(id: UUID, MKLocalSearchCompletion)] = []
    
    var isSearching: Bool {
        !searchQuery.isEmpty
    }
    
    var detent = PresentationDetent.height(200)
    
    override init() {
        super.init()
        completer.delegate = self
        
        completer.region = MKCoordinateRegion(center: [1.326552201722226, 103.81816571483735],
                                              span: MKCoordinateSpan(latitudeDelta: 0.371424832622929, longitudeDelta: 0.456988498626302))
    }
    
    var searchQuery: String = "" {
        didSet {
            if !searchQuery.isEmpty {
                completer.queryFragment = searchQuery
            } else {
                locationResults = []
            }
        }
    }
    
    func performLocalSearch(for completion: MKLocalSearchCompletion) async -> MKMapItem? {
        let request: MKLocalSearch.Request = .init(naturalLanguageQuery: completion.title)
        request.region = completer.region
        
        let search = MKLocalSearch(request: request)
        
        let response = try? await search.start()
        
        return response?.mapItems.first
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        locationResults = completer.results.filter {
            $0.subtitle != "Search Nearby"
        }.map { (UUID(), $0) }
    }
}
