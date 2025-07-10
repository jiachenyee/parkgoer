//
//  RoutePlanningManager.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/10/25.
//

import Foundation
import Observation
import FoundationModels
import MapKit
import SwiftData

@Observable
final class RoutePlanningManager {
    
    static let isRoutePlanningAvailable = true
    static let isSavedRoutesAvailable = false
    
    let isSurpriseMeAvailable: Bool
    
    #warning("properly handle shit here")
    var startParking: Parking? {
        didSet {
            reloadRouting()
        }
    }
    
    var endParking: Parking? {
        didSet {
            reloadRouting()
        }
    }
    
    func reloadRouting() {
        Task {
            route = try! await getBikeRoute()
        }
    }
    
    var route: Route?
    
    var tab: Tab = .plan
    
    var isParkingEnRouteEnabled = false {
        didSet {
            UserDefaults.standard.set(isParkingEnRouteEnabled, forKey: "isParkingEnRouteEnabled")
            reloadRouting()
        }
    }
    var selectedInterval: Int = 30 {
        didSet {
            UserDefaults.standard.set(selectedInterval, forKey: "selectedInterval")
            reloadRouting()
        }
    }
    
    var modelContext: ModelContext?
    
    init() {
        isParkingEnRouteEnabled = UserDefaults.standard.bool(forKey: "isParkingEnRouteEnabled")
        let udSelectedInterval = UserDefaults.standard.integer(forKey: "selectedInterval")
        selectedInterval = udSelectedInterval > 0 ? udSelectedInterval : 30
        
        if #available(iOS 26.0, *) {
            let systemModel = SystemLanguageModel(useCase: .general)
            isSurpriseMeAvailable = systemModel.isAvailable
        } else {
            isSurpriseMeAvailable = false
        }
    }
    
    let userTravellingSpeed: CLLocationSpeed = 10 / 3.6
    var distanceBeforeInterval: CLLocationDistance {
        userTravellingSpeed * (Double(selectedInterval - 5) * 60.0)
    }
    
    func getBikeRoute() async throws -> Route? {
        guard let startParking, let endParking, let modelContext else { return nil }
        
        guard let initialRoute = try await getMapRoute(start: startParking,
                                                       end: endParking) else { return nil }
        
        if isParkingEnRouteEnabled == false {
            return Route(intendedDurationBeforeStop: .greatestFiniteMagnitude,
                         subroutes: [initialRoute])
        }
        
        let routePoints = generateBreakPoints(from: initialRoute.coordinates)
        
        var routeParkingSpots: [(CLLocationCoordinate2D, ParkingAndDistance)] = []
        
        for point in routePoints {
            var nearestSpot: ParkingAndDistance?
            let latLongDiff = 0.002252 // Roughly 250 meters in latitude/longitude difference
            
            let minLongitude = point.longitude - latLongDiff
            let maxLongitude = point.longitude + latLongDiff
            let minLatitude = point.latitude - latLongDiff
            let maxLatitude = point.latitude + latLongDiff
            
            let parking: [Parking] = try modelContext.fetch(FetchDescriptor(predicate: #Predicate {
                $0.qrCode != nil &&
                $0.longitude >= minLongitude &&
                $0.longitude <= maxLongitude &&
                $0.latitude >= minLatitude &&
                $0.latitude <= maxLatitude
            }))
            
            for spot in parking {
                let distance = point - spot.coordinate
                
                if distance < nearestSpot?.distance ?? .greatestFiniteMagnitude {
                    nearestSpot = ParkingAndDistance(parking: spot, distance: distance)
                }
            }
            
            if let nearestSpot {
                routeParkingSpots.append((point, nearestSpot))
            }
        }
        
        routeParkingSpots.insert((startParking.coordinate,
                                  ParkingAndDistance(parking: startParking, distance: 0)), at: 0)
        routeParkingSpots.append((endParking.coordinate,
                                  ParkingAndDistance(parking: endParking, distance: 0)))
        
        let subroutes: [Route.Subroute] = try await (0..<routeParkingSpots.count - 1)
            .asyncMap { index in
                
                let current = routeParkingSpots[index]
                let next = routeParkingSpots[index + 1]
                
                var subroute = try? await self.getMapRoute(start: current.1.parking,
                                                           end: next.1.parking)
                
                if subroute == nil {
                    subroute = try? await self.getMapRoute(start: current.1.parking,
                                                           end: next.1.parking,
                                                           mismatchEnd: next.0)
                }
                
                if subroute == nil {
                    subroute = try? await self.getMapRoute(start: current.1.parking,
                                                           mismatchStart: current.0,
                                                           end: next.1.parking)
                }
                
                if subroute == nil {
                    subroute = try await self.getMapRoute(start: current.1.parking,
                                                           mismatchStart: current.0,
                                                           end: next.1.parking,
                                                           mismatchEnd: next.0)
                }
                
                return subroute!
            }
        
        return Route(intendedDurationBeforeStop: Double(selectedInterval * 60),
                     subroutes: subroutes.map {
            var mutableSubroute = $0
            mutableSubroute.overshot = $0.duration > Double(selectedInterval * 60)
            return mutableSubroute
        })
    }
    
    func generateBreakPoints(from coordinates: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D] {
        let points = generateEquidistantPoints(from: coordinates, spacing: 50)
        
        // chunk the points into intervals of 25 minutes
        var routePoints: [CLLocationCoordinate2D] = []
        var currentDistance: CLLocationDistance = 0
        
        for i in 0..<points.count - 1 {
            let start = points[i]
            let end = points[i + 1]
            
            let segmentDistance = start - end
            
            print(segmentDistance)
            currentDistance += segmentDistance
            
            if currentDistance >= distanceBeforeInterval {
                routePoints.append(end)
                currentDistance = 0
            }
        }
        
        return routePoints
    }
    
    func getMapRoute(start: Parking,
                     mismatchStart: CLLocationCoordinate2D? = nil,
                     end: Parking,
                     mismatchEnd: CLLocationCoordinate2D? = nil) async throws -> Route.Subroute? {
        let request = MKDirections.Request()
        request.transportType = .cycling
        request.highwayPreference = .avoid
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: mismatchStart ?? start.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: mismatchEnd ?? end.coordinate))
        
        let directions = MKDirections(request: request)
        
        let response = try await directions.calculate()
        
        if let extractedRoute = response.routes.first {
            return Route.Subroute(distance: extractedRoute.distance,
                                  advisoryNotices: extractedRoute.advisoryNotices,
                                  coordinates: extractedRoute.polyline.coordinates,
                                  start: start, end: end)
        } else {
            return nil
        }
    }
    
    func generateEquidistantPoints(from coordinates: [CLLocationCoordinate2D],
                                   spacing: CLLocationDistance) -> [CLLocationCoordinate2D] {
        guard coordinates.count >= 2 else { return coordinates }
        
        var result: [CLLocationCoordinate2D] = [coordinates.first!]
        var remainingDistance = spacing
        
        for i in 0..<coordinates.count - 1 {
            let start = coordinates[i]
            let end = coordinates[i + 1]
            
            let segmentDistance = start -  end
            let bearing = start.bearing(to: end)
            
            var traveled: CLLocationDistance = 0
            while remainingDistance < segmentDistance - traveled {
                traveled += remainingDistance
                let newPoint = start.coordinate(at: traveled, bearing: bearing)
                result.append(newPoint)
                remainingDistance = spacing
            }
            
            result.append(end)
            remainingDistance -= (segmentDistance - traveled)
            if remainingDistance < 0 { remainingDistance = spacing + remainingDistance }
        }
        
        return result
    }
    
    enum Tab: Int {
        case plan
        case savedRoutes
    }
}

public extension MKMultiPoint {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid,
                                              count: pointCount)
        
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        
        return coords
    }
}

extension CLLocationCoordinate2D {
    func bearing(to coordinate: CLLocationCoordinate2D) -> CLLocationDirection {
        let lat1 = latitude.radians
        let lon1 = longitude.radians
        let lat2 = coordinate.latitude.radians
        let lon2 = coordinate.longitude.radians
        
        let deltaLon = lon2 - lon1
        let y = sin(deltaLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon)
        let radiansBearing = atan2(y, x)
        return radiansBearing.degrees
    }
    
    func coordinate(at distance: CLLocationDistance, bearing: CLLocationDirection) -> CLLocationCoordinate2D {
        let distRadians = distance / 6_371_000.0
        let bearingRad = bearing.radians
        
        let lat1 = latitude.radians
        let lon1 = longitude.radians
        
        let lat2 = asin(sin(lat1) * cos(distRadians) +
                        cos(lat1) * sin(distRadians) * cos(bearingRad))
        let lon2 = lon1 + atan2(sin(bearingRad) * sin(distRadians) * cos(lat1),
                                cos(distRadians) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2.degrees, longitude: lon2.degrees)
    }
}

extension FloatingPoint {
    var radians: Self { return self * .pi / 180 }
    var degrees: Self { return self * 180 / .pi }
}

extension Sequence {
    func concurrentMap<T>(_ transform: @escaping (Element) async throws -> T) async throws -> [T] {
        let tasks = map { element in
            Task {
                try await transform(element)
            }
        }
        
        return try await tasks.asyncMap { task in
            try await task.value
        }
    }
    
    func asyncMap<T>(_ transform: (Element) async throws -> T) async rethrows -> [T] {
        var values = [T]()
        
        for element in self {
            try await values.append(transform(element))
        }
        
        return values
    }
}
