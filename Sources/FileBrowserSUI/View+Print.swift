//
//  File.swift
//  
//
//  Created by Richard Legault on 2021-01-17.
//

import Foundation
import SwiftUI

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v)}
        return EmptyView()
    }
}
