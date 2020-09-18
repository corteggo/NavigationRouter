//
//  Copyright (c) 2020 Cristian Ortega Gómez (https://github.com/corteggo)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

/// Navigation router
open class NavigationRouter: Router {
    // MARK: - Fields
    
    // MARK: Static fields
    
    /// Main navigation router
    public static let main: NavigationRouter = NavigationRouter()
    
    /// Authentication handler
    public static var authenticationHandler: RouterAuthenticationHandler?
    
    /// Error handler
    public static var errorHandler: RouterErrorHandler?
    
    /// External navigation delay
    static var externalNavigationDelay: TimeInterval = 1
    
    /// Registered routes
    static var routes: Set<NavigationRoute> = []
    
    /// Interceptors array
    static var interceptors: [NavigationInterceptor] = []
    
    /// Gets whether user is authenticated or not
    static var isUserAuthenticated: Bool {
        // Defaults to true
        return authenticationHandler?.isAuthenticated ?? true
    }
    
    // MARK: Instance fields
    
    /// Dispatch queue for background operations
    let dispatchQueue: DispatchQueue
    
#if canImport(SwiftUI)
    /// Associated scene
    @available(iOS 13.0, macOS 10.15, *)
    private(set) lazy var scene: UIScene? = nil
#endif
    
    /// Key window for associated scene (if any)
    var keyWindow: UIWindow? {
        if #available(iOS 13.0, macOS 10.15, *), let scene: UIScene = scene {
            return UIWindow.keyWindow(forScene: scene)
        } else {
            return UIWindow.keyWindow // first active scene
        }
    }
    
    // MARK: - Initializers
    
    /// Initialializes a new instance with key window
    private init() {
        self.dispatchQueue = DispatchQueue(
            label: "NavigationRouter-\(UUID().uuidString)",
            qos: .userInitiated,
            attributes: .concurrent,
            autoreleaseFrequency: .inherit,
            target: .global())
    }
    
    /// Initializes a new instance with given scene
    /// - Parameter scene: UIScene instance to use router for
    @available(iOS 13.0, macOS 10.15, *)
    convenience init(scene: UIScene) {
        self.init()
        
        self.scene = scene
    }
    
    // MARK: - Static methods
    
    // MARK: Navigation binding
    
    /// Binds given routes
    /// - Parameter routes: Routes to be registered
    public static func bind(routes: [NavigationRoute]) {
        for route in routes {
            Self.bind(route: route)
        }
    }
    
    /// Binds given route
    /// - Parameter route: Route to be registered
    public static func bind(route: NavigationRoute) {
        // Ensure route is not already registered
        guard !Self.routes.contains(route) else {
            return
        }
        
        // Register route
        _ = Self.routes.insert(route)
    }
    
    /// Unbind given routes
    /// - Parameter routes: Routes to be unregistered
    public static func unbind(routes: [NavigationRoute]) {
        for route in routes {
            Self.removeInterceptors(forPath: route.path)
            Self.unbind(route: route)
        }
    }
    
    /// Unbinds given route
    /// - Parameter route: Route to be unregistered
    public static func unbind(route: NavigationRoute) {
        Self.routes.remove(route)
    }
}
