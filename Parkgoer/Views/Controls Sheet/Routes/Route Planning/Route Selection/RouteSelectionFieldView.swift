//
//  RouteSelectionFieldView.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/10/25.
//

import SwiftUI

struct RouteSelectionFieldView: View {
    
    @Binding var parking: Parking?
    
    var namespace: Namespace.ID
    
    var isStart: Bool
    
    var body: some View {
        HStack {
            Button {
                
            } label: {
                if let parking {
                    Text(parking.beautifiedName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .matchedGeometryEffect(id: parking.id, in: namespace)
                } else {
                    Text(isStart ? "Select Start Point" : "Select End Point")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
            }
            
            if parking != nil {
                Button {
                    parking = nil
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.circle)
                .padding(.trailing)
                .foregroundStyle(.secondary)
            }
        }
        .foregroundColor(parking == nil ? .secondary : .primary)
    }
}
