//
//  ToolbarModifier.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/10/25.
//

import Foundation
import SwiftUI
import CoreLocation

struct ToolbarViewModifier: ViewModifier {
    
    @Environment(BicycleFetchManager.self) private var bicycleManager
    @Environment(NavigationManager.self) private var navigationManager
    
    var location: CLLocationCoordinate2D?
    
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            @Bindable var navigationManager = navigationManager
            
            content
                .toolbar {
                    ToolbarItem {
                        Group {
                            Button {
                                if !bicycleManager.isLoading {
                                    navigationManager.isReloadDataConfirmationPresented = true
                                }
                            } label: {
                                if bicycleManager.isLoading {
                                    ProgressView()
                                } else {
                                    Image(systemName: "arrow.clockwise")
                                }
                            }
                        }
                        .badge(bicycleManager.needsUpdate ? 1 : 0)
                    }
                    
                    if let location {
                        ToolbarItem(placement: .topBarLeading) {
                            WeatherView(location: location, isShowAllQRAlertPresented: $navigationManager.isShowAllQRAlertPresented)
                        }
                    }
                    
//                    ToolbarSpacer(placement: .topBarLeading)
//                    
//                    ToolbarItem(placement: .topBarLeading) {
//                        Toggle(isOn: $navigationManager.isRoutePresented) {
//                            Label("Generate Route",
//                                  systemImage: "point.bottomleft.forward.to.point.topright.filled.scurvepath")
//                        }
//                    }
                }
        } else {
            content
        }
    }
}
