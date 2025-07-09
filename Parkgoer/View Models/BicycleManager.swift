//
//  BicycleManager.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/7/25.
//

import Foundation
import Observation
import SwiftUI
import SwiftData

@Observable
class BicycleFetchManager {
    
    var needsUpdate: Bool = false
    
    static let url = URL(string: "https://raw.githubusercontent.com/jiachenyee/sg-bicycle-qr/refs/heads/main/data/bicycle_parking_locations.json")!
    
    static let lastUpdated = URL(string: "https://raw.githubusercontent.com/jiachenyee/sg-bicycle-qr/refs/heads/main/data/last_updated.txt")!
    
    var modelContext: ModelContext?
    
    var isLoading = false
    
    func getLastUpdatedDate() async -> String? {
        var request = URLRequest(url: Self.lastUpdated)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            guard let dateString = String(data: data, encoding: .utf8) else {
                print("Failed to decode date string.")
                return nil
            }
            
            print("LASTUPDATED: \(dateString)")
            return dateString
        } catch {
            return nil
        }
    }
    
    func needsToAutoFetch() async -> Bool {
        UserDefaults.standard.string(forKey: "lastUpdated") == nil
    }
    
    func checkForDatasetUpdate() async -> Bool {
        guard let lastUpdatedDate = await getLastUpdatedDate() else { return false }
        
        let internalLastUpdated = UserDefaults.standard.string(forKey: "lastUpdated")
            
        if lastUpdatedDate == internalLastUpdated {
            return false
        } else {
            return true
        }
    }
    
    func fetchParkingData() async throws {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        guard let modelContext = modelContext else {
            fatalError("Model context is not set.")
        }
        
        // Check if the dataset needs to be updated
        guard let lastUpdatedDate = await getLastUpdatedDate() else {
            print("Failed to fetch last updated date.")
            throw URLError(.badServerResponse)
        }
        
        guard lastUpdatedDate != UserDefaults.standard.string(forKey: "lastUpdated") else {
            print("No update needed, using cached data.")
            needsUpdate = false
            return
        }
        
        var request = URLRequest(url: Self.url)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        #warning("add proper error handling")
        let (data, response) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        
        let decodedResponse = try decoder.decode(DataWrapper.self, from: data).data
        
        do {
            try modelContext.delete(model: Parking.self)
        } catch {
            print("Failed to delete students.")
        }
        
        for parking in decodedResponse {
            modelContext.insert(parking)
        }
        
        try modelContext.save()
        
        UserDefaults.standard.set(lastUpdatedDate, forKey: "lastUpdated")
        needsUpdate = false
    }
}

struct DataWrapper: Decodable {
    var data: [Parking]
}
