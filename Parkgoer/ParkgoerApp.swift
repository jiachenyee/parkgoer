//
//  ParkgoerApp.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/3/25.
//

import SwiftUI
import SwiftData
import MapKit

@main
struct ParkgoerApp: App {
    
    @State private var mapFilterRegion: MapFilterRegion = .init(loadFullData: false)
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Parking.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(mapFilterRegion: $mapFilterRegion)
        }
        .modelContainer(sharedModelContainer)
    }
}
