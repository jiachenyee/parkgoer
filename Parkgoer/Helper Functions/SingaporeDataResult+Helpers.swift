//
//  SingaporeDataResult+Helpers.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/9/25.
//

import Foundation
import SingaporeKit

extension SingaporeDataResult: @retroactive Equatable {
    public static func == (lhs: SingaporeDataResult, rhs: SingaporeDataResult) -> Bool {
        let lhsRawState: Int
        
        switch lhs {
        case .failure: lhsRawState = 1
        case .loading: lhsRawState = 2
        case .success: lhsRawState = 3
        case .none: lhsRawState = 4
        }
        
        let rhsRawState: Int
        switch rhs {
        case .failure: rhsRawState = 1
        case .loading: rhsRawState = 2
        case .success: rhsRawState = 3
        case .none: rhsRawState = 4
        }
        
        return lhsRawState == rhsRawState
    }
}
