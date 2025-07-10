//
//  ParkingSpotRowView.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/11/25.
//

import SwiftUI

struct ParkingSpotRowView: View {
    
    var action: (() -> Void)
    
    var spot: ParkingAndDistance
    
    var description: String?
    
    @ScaledMetric(relativeTo: .title3) private var symbolWidth = 48.0

    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: spot.parking.rackType.symbol)
                    .font(.title3)
                    .foregroundStyle(Color.accentColor)
                    .frame(width: symbolWidth)
                    .padding(.vertical, 4)
                    .overlay {
                        if spot.parking.rackType.isYellowBox {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.yellow, lineWidth: 2)
                        }
                    }
                    .padding(.trailing, 8)
                
                VStack(alignment: .leading) {
                    Text(spot.parking.beautifiedName)
                        .font(.headline)
                    HStack(alignment: .top) {
                        if spot.parking.qrCode == nil {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.yellow)
                        }
                        
                        if let description {
                            Text(description)
                                .foregroundStyle(.secondary)
                        } else {
                            Text(spot.displaySubtitle)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                    .padding(.trailing)
            }
            .multilineTextAlignment(.leading)
            .padding(.vertical)
        }
        .foregroundStyle(Color(uiColor: .label),
                         Color(uiColor: .secondaryLabel))
    }
}
