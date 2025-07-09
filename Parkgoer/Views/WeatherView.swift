//
//  WeatherView.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/9/25.
//

import SwiftUI
import SingaporeKit
import CoreLocation

struct WeatherView: View {
    
    var location: CLLocationCoordinate2D
    
    @Singapore(\.twoHourWeather) private var twoHourWeather
    @Singapore(\.airTemperature) private var temperature
    
    @Binding var isShowAllQRAlertPresented: Bool
    
    @State private var tapCount = 0
    
    var body: some View {
        HStack(spacing: 8) {
            switch twoHourWeather {
            case .success(let data):
                let latestWeather = data.latest
                
                if let closestWeather = latestWeather.locations.sorted(by: {
                    ($0.location?.coordinate ?? [0, 0]) - location < ($1.location?.coordinate ?? [0, 0]) - location
                }).first {
                    Image(systemName: closestWeather.forecast.systemImage)
                        .font(.headline)
                        .frame(width: 48)
                }
            default: EmptyView()
            }

            switch temperature {
            case .success(let data):
                if let closestStation = data.stations.sorted(by: {
                    $0.location.coordinate - location < $1.location.coordinate - location
                }).first,
                   let reading = data.latestReading(for: closestStation) {
                    Text("\(String(format: "%.1f", reading))℃")
                        .monospacedDigit()
                        .frame(width: 72, alignment: .leading)
                        .contentTransition(.numericText(value: reading))
                }
            default: EmptyView()
            }
        }
        .animation(.bouncy, value: twoHourWeather)
        .animation(.bouncy, value: temperature)
        .onTapGesture {
            tapCount += 1
            
            if tapCount == 10 {
                isShowAllQRAlertPresented = true
            } else if tapCount > 10 {
                tapCount = 0
            }
        }
    }
}
