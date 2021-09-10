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

import NavigationRouter

/// Test feature 3 module definition
@MainActor public final class TestFeature3Module: RoutableModule {
    // MARK: - Initializers
    
    /// Initializes a new instance
    public init() {
        // Initialize instance here as needed
    }
    
    // MARK: - Routing
    
    /// Registers navigation routers
    public func registerRoutes() {
        // Define routes
        let view3ARoute: NavigationRoute = NavigationRoute(path: "/view3A",
                                                          type: ViewModel3A.self,
                                                          requiresAuthentication: false)
        let view3BRoute: NavigationRoute = NavigationRoute(path: "/view3B",
                                                          type: ViewModel3B.self,
                                                          requiresAuthentication: false)
        let view3CRoute: NavigationRoute = NavigationRoute(path: "/view3C",
                                                           type: ViewModel3C.self,
                                                           requiresAuthentication: false)
        let view3DRoute: NavigationRoute = NavigationRoute(path: "/view3D",
                                                           type: ViewModel3D.self,
                                                           requiresAuthentication: false)
        let view3ERoute: NavigationRoute = NavigationRoute(path: "/view3E",
                                                           type: ViewModel3E.self,
                                                           requiresAuthentication: false)
        
        // Register routes
        NavigationRouter.bind(routes: [
            view3ARoute,
            view3BRoute,
            view3CRoute,
            view3DRoute,
            view3ERoute
        ])
    }
    
    /// Registers interceptors
    public func registerInterceptors() {
        // Intercept view 2D
        NavigationRouter.interceptNavigation(
            toPath: "/view2D",
            when: .after,
            withPriority: .low,
            isAuthenticationRequired: false) { router, executionFlow in
            let interceptionFlow: NavigationInterceptionFlow = NavigationInterceptionFlow(completion: executionFlow)
            router.navigate(toPath: "/view3D",
                                           modal: true,
                                           interceptionExecutionFlow: interceptionFlow)
        }
        
        // Intercept view 2E
        NavigationRouter.interceptNavigation(
            toPath: "/view2E",
            when: .before,
            withPriority: .low,
            isAuthenticationRequired: false) { router, executionFlow in
            let interceptionFlow: NavigationInterceptionFlow = NavigationInterceptionFlow(completion: executionFlow)
            router.navigate(toPath: "/view3E",
                                           interceptionExecutionFlow: interceptionFlow)
        }
    }
}
