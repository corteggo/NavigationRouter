//
//  SwiftUIView+TypeErasure.swift
//  NavigationRouter
//
//  Created by Cristian Ortega on 16/07/2020.
//  Copyright © 2020 Cristian Ortega Gómez. All rights reserved.
//

#if canImport(SwiftUI)
import SwiftUI

// MARK: - Type erasure
@available(iOS 13.0, macOS 10.15, *)
public extension View {
    /// Erases current view as AnyView
    /// - Returns: AnyView representing current view
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
#endif
