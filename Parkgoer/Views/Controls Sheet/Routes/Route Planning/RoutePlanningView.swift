//
//  RoutePlanningView.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/10/25.
//

import SwiftUI
import Combine
import MapKit
import SwiftData

struct RoutePlanningView: View {
    
    @Environment(NavigationManager.self) private var navigationManager
    @Environment(RoutePlanningManager.self) private var routePlanningManager
    
    @Binding var selectedParking: Parking?
    
    var body: some View {
        @Bindable var routePlanningManager = routePlanningManager
        
        ScrollView {
            RouteSelectionView()
            
            VStack(alignment: .leading) {
                Toggle("Find parking en route",
                       systemImage: "parkingsign.radiowaves.left.and.right",
                       isOn: $routePlanningManager.isParkingEnRouteEnabled)
                Text("If you use bike sharing services, you can set a parking interval to find parking spots to reset your journey along your route.")
                    .font(.caption)
                
                if routePlanningManager.isParkingEnRouteEnabled {
                    if #available(iOS 26, *) {
                        Picker("Every", selection: $routePlanningManager.selectedInterval) {
                            let intervals = [20, 25, 30, 35, 40, 45, 50, 55, 60]
                            
                            ForEach(intervals, id: \.self) { interval in
                                Text("Every \(interval) min")
                                    .tag(interval)
                            }
                        }
                        .glassEffect(.regular)
                    }
                }
            }
            .padding(.bottom)
            
            if let route = routePlanningManager.route {
                Divider()
                
                VStack(alignment: .leading) {
                    HStack {
                        VStack {
                            Text("\(route.allParkings.count)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text("Stops")
                        }
                        .frame(maxWidth: .infinity)
                        Divider()
                        VStack {
                            Text(Measurement<UnitLength>(value: route.distance, unit: .meters).formatted())
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text("Distance")
                        }
                        .frame(maxWidth: .infinity)
                        Divider()
                        VStack {
                            Text(route.formattedDuration)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text("Duration")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    HStack {
                        Image(systemName: "flag")
                            .font(.system(size: 24))
                            .frame(width: 48, height: 48)
                            .background(.ultraThinMaterial)
                            .clipShape(.circle)
                        
                        Button(route.firstStop.beautifiedName) {
                            selectedParking = route.firstStop
                        }
                    }
                    .buttonStyle(.bordered)
                    
                    ForEach(route.subroutes) { subroute in
                        HStack {
                            if subroute.overshot == true {
                                Rectangle()
                                    .fill(.yellow)
                                    .frame(width: 4)
                                    .padding(.horizontal, 22)
                                    .padding(.vertical, -8)
                                    .zIndex(-1)
                                
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.yellow)
                                Text(subroute.subtitle)
                            } else {
                                Rectangle()
                                    .fill(.blue)
                                    .frame(width: 4)
                                    .padding(.horizontal, 22)
                                    .padding(.vertical, -8)
                                    .zIndex(-1)
                                
                                Text(subroute.subtitle)
                            }
                        }
                        
                        HStack {
                            Image(systemName: subroute.end == route.lastStop ? "flag.fill" : "mappin")
                                .font(.system(size: 24))
                                .frame(width: 48, height: 48)
                                .background(.ultraThinMaterial)
                                .clipShape(.circle)
                            
                            Button(subroute.end.beautifiedName) {
                                selectedParking = subroute.end
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
//            if routePlanningManager.isSurpriseMeAvailable && (routePlanningManager.startParking == nil || routePlanningManager.endParking == nil) {
//                SurpriseMeButtonView {
//                    
//                }
//            }
        }
        .animation(.default, value: routePlanningManager.isParkingEnRouteEnabled)
        .safeAreaPadding()
    }
}
