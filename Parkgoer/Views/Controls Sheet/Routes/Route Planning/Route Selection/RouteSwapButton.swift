//
//  RouteSwapButton.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/10/25.
//

import SwiftUI

struct RouteSwapButton: View {
    
    @Environment(RoutePlanningManager.self) private var routePlanningManager
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 1)
                .opacity(0.5)
            Button {
                withAnimation {
                    (routePlanningManager.startParking, routePlanningManager.endParking) = (routePlanningManager.endParking, routePlanningManager.startParking)
                }
            } label: {
                Image(systemName: "arrow.down")
            }
            .buttonBorderShape(.circle)
            .buttonStyle(.bordered)
        }
        .padding(.horizontal)
    }
}

#Preview {
    RouteSwapButton()
}
