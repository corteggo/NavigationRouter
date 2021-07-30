//
//  RouterGlobalInterceptor.swift
//  NavigationRouter
//
//  Created by Erik Kamalov on 14/5/21.
//  Copyright © 2021 Cristian Ortega Gómez. All rights reserved.
//

import Foundation

/// Interceptor handler interface for RouterGlobalInterceptor
public protocol RouterGlobalInterceptor {
    /// Handles given interceptor
    /// - Parameter error: Routing interceptor to be handled
    func interceptor(route path: String)
}
