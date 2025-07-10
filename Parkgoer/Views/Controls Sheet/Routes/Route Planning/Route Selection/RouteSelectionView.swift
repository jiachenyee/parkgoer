//
//  RouteSelectionView.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/10/25.
//

import SwiftUI

struct RouteSelectionView: View {
    
    @Environment(NavigationManager.self) private var navigationManager
    @Environment(RoutePlanningManager.self) private var routePlanningManager
    
    @Namespace var namespace
    
    var body: some View {
        @Bindable var routePlanningManager = routePlanningManager
        
        ZStack {
            VStack {
                RouteSelectionFieldView(parking: $routePlanningManager.startParking,
                                        namespace: namespace,
                                        isStart: true)
                
                RouteSelectionFieldView(parking: $routePlanningManager.endParking,
                                        namespace: namespace,
                                        isStart: false)
            }
            
            RouteSwapButton()
        }
        .modifier(RouteSelectionContainerModifier())
        .padding(.bottom)
    }
}

#Preview {
    RouteSelectionView()
}
