//
//  RoutePlanningView.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/10/25.
//

import SwiftUI

struct RoutePlanningView: View {
    var body: some View {
        VStack {
            if #available(iOS 26.0, *) {
                VStack(spacing: 0) {
                    Button {
                        
                    } label: {
                        Text("Start of Route")
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    
                    Divider()
                    
                    Button {
                        
                    } label: {
                        Text("End Route")
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                }
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 32), isEnabled: true)
            } else {
                // Fallback on earlier versions
            }
            
            Picker("Parking Interval", selection: .constant(0)) {
                let intervals = ["5 minutes", "10 minutes", "15 minutes", "20 minutes", "30 minutes"]
                
                ForEach(intervals, id: \.self) { interval in
                    Text(interval)
                        .tag(interval)
                }
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "bicycle")
                    .frame(width: 48, height: 48)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.circle)
        }
        .safeAreaPadding()
    }
}

#Preview {
    RoutePlanningView()
}
