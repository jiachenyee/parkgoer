//
//  QRView.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/7/25.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRView: View {
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var qrCode: String
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var copyButtonPressed = false
    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .leading) {
                if let qrImage = generateQRCode(from: qrCode) {
                    Image(uiImage: qrImage)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("Failed to generate QR code")
                }
                
                Text("Please ensure you park your bicycle responsibly at the designated parking spot.")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Button {
                    UIPasteboard.general.string = qrCode
                    copyButtonPressed = true
                } label: {
                    if copyButtonPressed {
                        Label("Copied!", systemImage: "checkmark")
                            .padding()
                            .frame(maxWidth: .infinity)
                    } else {
                        Label("Copy Code", systemImage: "document.on.document")
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .navigationTitle(qrCode)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", systemImage: "checkmark") {
                        dismiss()
                    }
                    .tint(.accentColor)
                }
            }
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return nil
    }
}
