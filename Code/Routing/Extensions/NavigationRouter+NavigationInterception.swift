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

/// Navigation interception enum
public enum NavigationInterceptorPoint: Int, Codable {
    /// Before navigating
    case before
    
    /// After navigating
    case after
}

/// Navigation interception priority
public enum NavigationInterceptionPriority: Int, Codable, Comparable {
    /// Low priority
    case low
    
    /// Medium priority
    case medium
    
    /// High priority
    case high
    
    /// Mandatory priority
    case mandatory
    
    // MARK: - Comparable
    
    /// Compares two given instances
    /// - Parameters:
    ///   - lhs: First instance to compare
    ///   - rhs: Second instance to compare
    public static func < (lhs: NavigationInterceptionPriority, rhs: NavigationInterceptionPriority) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

/// Navigation interceptor
struct NavigationInterceptor: Comparable {
    // MARK: - Fields
    
    /// Path
    var path: String
    
    /// Navigation interceptor point
    var when: NavigationInterceptorPoint
    
    /// Priority
    var priority: NavigationInterceptionPriority
    
    /// Whether the interceptor requires authentication or not
    var requiresAuthentication: Bool
    
    /// Handler
    var handler: ((NavigationRouter, ((Bool?) -> Void)?) -> Void)?
    
    // MARK: - Comparable
    
    /// Compares given instances
    /// - Parameters:
    ///   - lhs: First instance
    ///   - rhs:Second instance
    static func < (lhs: NavigationInterceptor, rhs: NavigationInterceptor) -> Bool {
        // Order by priority
        if lhs.priority > rhs.priority {
            return false
        }
        
        // Order by authentication
        if !lhs.requiresAuthentication && rhs.requiresAuthentication {
            return false
        }
        
        // In any other case, lhs < rhs
        return true
    }
    
    /// Gets whether two given instances are equal or not
    /// - Parameters:
    ///   - lhs: First instance
    ///   - rhs: Second instance
    static func == (lhs: NavigationInterceptor, rhs: NavigationInterceptor) -> Bool {
        return lhs.path.lowercased() == rhs.path.lowercased() &&
            lhs.when == rhs.when &&
            lhs.priority == rhs.priority &&
            lhs.requiresAuthentication == rhs.requiresAuthentication
    }
}

/// Navigation interception flow
public struct NavigationInterceptionFlow {
    // MARK: - Fields
    
    /// Completion handler to continue flow execution (if any)
    public var `continue`: ((Bool?) -> Void)?
    
    // MARK: - Initializers
    
    /// Initializes a new instance with given completion handler
    /// - Parameter completion: Completion handler to continue execution (if any)
    public init(completion: ((Bool?) -> Void)?) {
        self.continue = completion
    }
}

// MARK: - Navigation interception
extension NavigationRouter {
    // MARK: Interceptors
    
    /// Interceps navigation to given path with given handler
    /// - Parameters:
    ///   - interceptedPath: Path to intercept navigation for
    ///   - when: When to inercept navigation
    ///   - priority: Interception priority
    ///   - isAuthenticationRequired: Whether the interception requires authentication or not
    ///   - handler: Interception handler
    public static func interceptNavigation(
        toPath interceptedPath: String,
        when: NavigationInterceptorPoint = .before,
        withPriority priority: NavigationInterceptionPriority = .low,
        isAuthenticationRequired requiresAuthentication: Bool = false,
        handler: ((NavigationRouter, ((Bool?) -> Void)?) -> Void)?) {
        // Add interceptor
        self.interceptors.append(NavigationInterceptor(
            path: interceptedPath,
            when: when,
            priority: priority,
            requiresAuthentication: requiresAuthentication,
            handler: handler))
    }
    
    /// Removes all registered interceptors for given path
    /// - Parameter path: Path to remove interceptors for
    static func removeInterceptors(forPath path: String) {
        self.interceptors.removeAll(where: {
            $0.path.lowercased() == path.lowercased()
        })
    }
    
    // MARK: Event handlers
    
    /// Router will navigate handler
    /// - Parameter route: Route the router will navigate to
    /// - Parameter parameters: Parameters used for navigation
    /// - Parameter originalPath: Original navigation path
    /// - Parameter replace: Whether to replace the stack or not
    /// - Parameter externally: Whether to navigate externally or not
    /// - Parameter embedInNavigationView: Whether to embed destination view in a navigation view or not
    /// - Parameter modal: Whether to present the destination view as modal or not
    /// - Parameter shouldPreventDismissal: Whether the presented modal should prevent dismissal or not (if applicable)
    /// - Parameter animation: Navigation transition
    /// - Parameter completion: Completion handler
    func routerWillNavigate(
        toRoute route: NavigationRoute,
        withParameters parameters: [String: String]?,
        originalPath: String,
        replace: Bool = false,
        embedInNavigationView: Bool = true,
        modal: Bool = false,
        shouldPreventDismissal: Bool = false,
        animation: NavigationTransition? = nil,
        completion: @escaping (() -> Void)) {
        // Get interceptors for given path
        let interceptors: [NavigationInterceptor] = Self.interceptors
            .filter({ $0.path.lowercased() == route.path.lowercased() && $0.when == .before })
        guard !interceptors.isEmpty else {
            DispatchQueue.main.async {
                completion()
            }
            return
        }
        
        // Sort interceptors by priority
        let sortedInterceptors: [NavigationInterceptor] = interceptors.sorted(by: { $0 > $1 })
        
        // Execute each interceptor by priority and let them handle their own code asynchronously
        self.handleInterceptors(
            sortedInterceptors,
            when: .before,
            forRoute: route,
            withParameters: parameters,
            originalPath: originalPath,
            replace: replace,
            embedInNavigationView: embedInNavigationView,
            modal: modal,
            shouldPreventDismissal: shouldPreventDismissal,
            animation: animation,
            completion: completion)
    }
    
    /// Router did navigate handler
    /// - Parameter route: Route the router will navigate to
    /// - Parameter parameters: Parameters used for navigation
    /// - Parameter originalPath: Original navigation path
    /// - Parameter replace: Whether to replace the stack or not
    /// - Parameter externally: Whether to navigate externally or not
    /// - Parameter embedInNavigationView: Whether to embed destination view in a navigation view or not
    /// - Parameter modal: Whether to present the destination view as modal or not
    /// - Parameter shouldPreventDismissal: Whether the presented modal should prevent dismissal or not (if applicable)
    /// - Parameter animation: Transition animation (if any)
    func routerDidNavigate(
        toRoute route: NavigationRoute,
        withParameters parameters: [String: String]?,
        originalPath: String,
        replace: Bool = false,
        embedInNavigationView: Bool = true,
        modal: Bool = false,
        shouldPreventDismissal: Bool = false,
        animation: NavigationTransition? = nil) {
        // Get interceptors for given path
        let interceptors: [NavigationInterceptor] = Self.interceptors
            .filter({ $0.path.lowercased() == route.path.lowercased() && $0.when == .after })
        guard !interceptors.isEmpty else {
            return
        }
        
        // Sort interceptors by priority
        let sortedInterceptors: [NavigationInterceptor] = interceptors.sorted(by: { $0 > $1 })
        
        // Execute each interceptor by priority and let them handle their own code asynchronously
        self.handleInterceptors(
            sortedInterceptors,
            when: .after,
            forRoute: route,
            withParameters: parameters,
            originalPath: originalPath,
            replace: replace,
            embedInNavigationView: embedInNavigationView,
            modal: modal,
            shouldPreventDismissal: shouldPreventDismissal,
            animation: animation)
    }
    
    /// Handles given interceptors
    /// - Parameters:
    ///   - interceptors: Interceptors to be handled
    ///   - route: Route to navigate to
    ///   - parameters: Parameters to use for navigation
    ///   - originalPath: Original navigation path
    ///   - replace: Whether to replace the stack with the destination view or not
    ///   - externally: Whether to navigate externally or not
    ///   - embedInNavigationView: Whether to embed the destination view in a navigation view or not
    ///   - modal: Whether to use a modal presentation style for the destination view or not
    ///   - shouldPreventDismissal: Whether the presented modal (if applicable) should prevent dismissal or not
    ///   - when: Interception point
    ///   - animation: Transition animation (if any)
    ///   - completion: Completion handler (if any)
    private func handleInterceptors(
        _ interceptors: [NavigationInterceptor],
        when: NavigationInterceptorPoint,
        forRoute route: NavigationRoute,
        withParameters parameters: [String: String]?,
        originalPath: String,
        replace: Bool = false,
        embedInNavigationView: Bool = true,
        modal: Bool = false,
        shouldPreventDismissal: Bool = false,
        animation: NavigationTransition? = nil,
        completion: (() -> Void)? = nil) {
        
        // Get interceptor to handle
        guard let interceptorToHandle: NavigationInterceptor = interceptors.first else {
            return
        }
        
        // Declare interception completion handler
        let interceptionCompletionHandler: ((Bool?) -> Void) = { (originalNavigationMustBeCancelled: Bool?) in
            // Check if handled interceptor was the last one (or the only one)
            if interceptors.count == 1 {
                // Ensure original navigation must not be cancelled (if needed)
                if when == .before && !(originalNavigationMustBeCancelled ?? false) {
                    // Perform original navigation
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            } else if !(originalNavigationMustBeCancelled ?? false) {
                // Let the next interceptor handle its own code before actually navigating to the original path
                self.handleInterceptors(Array(
                    interceptors.dropFirst()),
                    when: when,
                    forRoute: route,
                    withParameters: parameters,
                    originalPath: originalPath,
                    replace: replace,
                    embedInNavigationView: embedInNavigationView,
                    modal: modal,
                    shouldPreventDismissal: shouldPreventDismissal,
                    animation: animation,
                    completion: completion
                )
            }
            
            // Otherwise we do not need to do anything since the original navigation has been cancelled at some point
        }
        
        // Check if interceptor requires authentication
        if interceptorToHandle.requiresAuthentication,
            !(Self.authenticationHandler?.isAuthenticated ?? false) {
            Self.authenticationHandler?.login(completion: {
                self.executeInterceptor(interceptorToHandle, completion: interceptionCompletionHandler)
            })
        } else {
            self.executeInterceptor(interceptorToHandle, completion: interceptionCompletionHandler)
        }
    }
    
    /// Executes interceptor
    private func executeInterceptor(
        _ interceptor: NavigationInterceptor,
        completion: ((Bool?) -> Void)?) {
        DispatchQueue.main.async {
            interceptor.handler?(self, completion)
        }
    }
}
