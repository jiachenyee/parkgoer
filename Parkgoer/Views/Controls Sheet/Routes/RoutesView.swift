//
//  RoutesView.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/10/25.
//

import SwiftUI

struct RoutesView: View {
    
    @Environment(RoutePlanningManager.self) private var routePlanningManager
    
    @Binding var selectedParking: Parking?
    
    var body: some View {
        
        @Bindable var routePlanningManager = routePlanningManager
        
        VStack {
            if RoutePlanningManager.isSavedRoutesAvailable {
                Picker("Tab", selection: $routePlanningManager.tab) {
                    Text("Plan").tag(RoutePlanningManager.Tab.plan)
                    Text("Saved Routes").tag(RoutePlanningManager.Tab.savedRoutes)
                }
                .pickerStyle(.palette)
                .padding(.horizontal)
                .padding(.top)
            }
            
            switch routePlanningManager.tab {
            case .plan:
                RoutePlanningView(selectedParking: $selectedParking)
            case .savedRoutes:
                Spacer()
                #warning("to implement saved routes")
            }
        }
    }
}
