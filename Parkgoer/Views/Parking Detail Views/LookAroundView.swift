//
//  LookAroundView.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/8/25.
//

import SwiftUI
import MapKit

struct LookAroundView: View {
    
    let coordinate: CLLocationCoordinate2D
    
    @State private var lookAroundScene: MKLookAroundScene? = nil
    
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            if let lookAroundScene {
                LookAroundPreview(initialScene: lookAroundScene, badgePosition: .topTrailing)
                    .ignoresSafeArea(.all, edges: .top)
                    .frame(height: 200)
                    .clipShape(.rect(cornerRadius: 16, style: .continuous))
                    .padding(.top)
            } else {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .onChange(of: coordinate) { oldValue, newValue in
            isLoading = true
            Task {
                lookAroundScene = nil
                
                do {
                    let scene = try await MKLookAroundSceneRequest(coordinate: coordinate).scene
                    withAnimation {
                        lookAroundScene = scene
                        isLoading = false
                    }
                } catch {
                    lookAroundScene = nil
                    isLoading = false
                }
            }
        }
        .task {
            lookAroundScene = nil
            
            do {
                let scene = try await MKLookAroundSceneRequest(coordinate: coordinate).scene
                withAnimation {
                    lookAroundScene = scene
                    isLoading = false
                }
            } catch {
                lookAroundScene = nil
                isLoading = false
            }
        }
    }
}
