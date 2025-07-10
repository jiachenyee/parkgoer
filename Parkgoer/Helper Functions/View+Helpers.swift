//
//  View+Helpers.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/10/25.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
