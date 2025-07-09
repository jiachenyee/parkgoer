//
//  LegacyControlsLayerView.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/10/25.
//

import SwiftUI
import MapKit

struct LegacyControlsLayerView: View {
    
    var mapFilterRegion: MapFilterRegion
    
    @Binding var isReloadDataConfirmationPresented: Bool
    @Binding var isShowAllQRAlertPresented: Bool
    
    @Environment(BicycleFetchManager.self) private var bicycleManager
    
    var body: some View {
        if #unavailable(iOS 26.0) {
            VStack(alignment: .leading) {
                if let location = mapFilterRegion.region?.center {
                    WeatherView(location: location,
                                isShowAllQRAlertPresented: $isShowAllQRAlertPresented)
                        .frame(height: 48)
                        .background(.thickMaterial)
                        .clipShape(.rect(cornerRadius: 16, style: .continuous))
                }
                
                Group {
                    if bicycleManager.isLoading {
                        ProgressView()
                            .frame(width: 48, height: 48)
                            .background(.thickMaterial)
                            .clipShape(.rect(cornerRadius: 16, style: .continuous))
                    } else {
                        Button {
                            isReloadDataConfirmationPresented = true
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .frame(width: 48, height: 48)
                                .background(.thickMaterial)
                                .clipShape(.rect(cornerRadius: 16, style: .continuous))
                        }
                        .badge(bicycleManager.needsUpdate ? 1 : 0)
                    }
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}
