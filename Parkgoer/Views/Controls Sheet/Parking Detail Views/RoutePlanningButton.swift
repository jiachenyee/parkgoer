//
//  RoutePlanningButton.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/10/25.
//

import SwiftUI

struct RoutePlanningButton: View {
    
    var parking: Parking
    
    @Binding var selectedParking: Parking?
    
    @Environment(RoutePlanningManager.self) private var routePlanningManager
    @Environment(NavigationManager.self) private var navigationManager
    
    var body: some View {
        if RoutePlanningManager.isRoutePlanningAvailable {
            Menu {
                Button("From here", systemImage: "point.bottomleft.forward.to.point.topright.filled.scurvepath") {
                    routePlanningManager.startParking = parking
                    navigationManager.isRoutePresented = true
                    selectedParking = nil
                }
                
                Button("To here", systemImage: "point.bottomleft.filled.forward.to.point.topright.scurvepath") {
                    routePlanningManager.endParking = parking
                    navigationManager.isRoutePresented = true
                    selectedParking = nil
                }
            } label: {
                Label("Plan Route", systemImage: "point.bottomleft.forward.to.point.topright.filled.scurvepath")
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
