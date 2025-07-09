//
//  ParkingSpotDataView.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/8/25.
//

import SwiftUI

struct ParkingSpotDataView: View {
    
    var spot: Parking
    
    var body: some View {
        HStack {
            VStack(spacing: 0) {
                Text("\(spot.rackCount)")
                    .font(.system(size: 32, weight: .bold))
                    .frame(height: 48)
                Text("spots")
            }
            .frame(maxWidth: .infinity)
            
            Divider()
            
            VStack(spacing: 0) {
                if spot.rackType.isYellowBox {
                    Image(systemName: "rectangle")
                        .foregroundStyle(.yellow)
                        .font(.system(size: 32, weight: .bold))
                        .frame(height: 48)
                } else {
                    Image(systemName: "rectangle.split.3x1")
                        .foregroundStyle(.mint)
                        .font(.system(size: 32, weight: .bold))
                        .frame(height: 48)
                }
                Text(spot.rackType.isYellowBox ? "yellow box" : "bike racks")
            }
            .frame(maxWidth: .infinity)
            
            Divider()
            
            VStack(spacing: 0) {
                Image(systemName: spot.shelterIndicator ? "umbrella" : "cloud.rain")
                    .font(.system(size: 32, weight: .bold))
                    .frame(height: 48)
                    .foregroundStyle(spot.shelterIndicator ? .indigo : .gray)
                Text(spot.shelterIndicator ? "sheltered" : "unsheltered")
            }
            .frame(maxWidth: .infinity)
        }
    }
}
