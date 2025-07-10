//
//  ParkingQRButton.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/8/25.
//

import SwiftUI

struct ParkingQRButton: View {
    
    var distance: Double
    var parking: Parking
    
    @State private var isQRPresented: Bool = false
    @AppStorage("showAllQR") private var showAllQR = false
    
    var body: some View {
        if let qrCode = parking.qrCode {
            Group {
                if showAllQR || distance <= 100 {
                    Button {
                        isQRPresented.toggle()
                    } label: {
                        Label("Parking QR Code", systemImage: "qrcode")
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                } else {
                    Text("Be within 100 m of the parking spot to access the parking QR code.")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .sheet(isPresented: $isQRPresented) {
                QRView(qrCode: qrCode)
            }
        } else {
            Text("QR code is unavailable for this parking spot.")
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
