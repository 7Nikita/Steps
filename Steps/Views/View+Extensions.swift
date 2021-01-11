//
//  View+Extensions.swift
//  Steps
//
//  Created by Nikita Pekurin on 7.01.21.
//

import SwiftUI
import Foundation


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
