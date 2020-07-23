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

import Foundation

/// Router protocol
public protocol Router {
    // MARK: - Routes
    
    /// Bind given route
    /// - Parameter route: Route to bind
    static func bind(route: NavigationRoute)
    
    /// Bind given routes
    /// - Parameter routes: Routes to bind
    static func bind(routes: [NavigationRoute])
    
    /// Unbind given route
    /// - Parameter route: Route to unbind
    static func unbind(route: NavigationRoute)
    
    /// Unbind given routes
    /// - Parameter routes: Routes to unbind
    static func unbind(routes: [NavigationRoute])
    
    // MARK: - Interception
    
    /// Intercepts navigation for specified path
    /// - Parameters:
    ///   - interceptedPath: Path to intercept
    ///   - when: When to intercept navigation
    ///   - priority: Interception priority
    ///   - isAuthenticationRequired: Whether the interception requires authentication or not
    ///   - handler: Interception handler
    static func interceptNavigation(
        toPath interceptedPath: String,
        when: NavigationInterceptorPoint,
        withPriority priority: NavigationInterceptionPriority,
        isAuthenticationRequired requiresAuthentication: Bool,
        handler: ((NavigationRouter, ((Bool?) -> Void)?) -> Void)?)
    
    // MARK: - Navigation
    
    /// Navigates to given path with given data
    /// - Parameters:
    ///   - path: Path to navigate to
    ///   - replace: Whether to replace navigation stack or not
    ///   - externally: Whether the navigation is from an external source or not
    ///   - embedInNavigationView: Whether to embed the destination view into a UINavigationController instance or not
    ///   - modal: Whether to show destination view as modal or not
    ///   - shouldPreventDismissal: Whether the presented modal should prevent dismissal or not
    ///   - interceptionExecutionFlow: Navigation interception execution flow
    ///   - animation: Navigation animation for stack replacing (if any)
    func navigate(
        toPath path: String,
        replace: Bool,
        externally: Bool,
        embedInNavigationView: Bool,
        modal: Bool,
        shouldPreventDismissal: Bool,
        interceptionExecutionFlow: NavigationInterceptionFlow?,
        animation: NavigationTransition?)
}
