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
import UIKit
#if canImport(SwiftUI)
import SwiftUI
#endif

// MARK: - Navigation handling
extension NavigationRouter {
    /// Navigates to given path
    /// - Parameters:
    ///   - path: Path to navigate to
    ///   - replace:    Whether to replace the stack or not
    ///   - externally: Whether the navigation was launched externally or not. Defaults to false.
    ///   - embedInNavigationView: Whether to embed the view in a NavigationView or not
    ///   - modal: Whether to present navigation as modal or not
    ///   - shouldPreventDismissal: Whether modal dismissal should be prevented or not
    ///   - interceptionExecutionFlow: Navigation interception execution flow (if any)
    ///   - animation: Animation to use for navigation
    open func navigate(
        toPath path: String,
        replace: Bool = false,
        externally: Bool = false,
        embedInNavigationView: Bool = true,
        modal: Bool = false,
        shouldPreventDismissal: Bool = false,
        interceptionExecutionFlow: NavigationInterceptionFlow? = nil,
        animation: NavigationTransition? = nil) {
        
        self.dispatchQueue.async {
            self.checkNavigationRequirementsAndNavigate(toPath: path,
                                                        replace: replace,
                                                        externally: externally,
                                                        embedInNavigationView: embedInNavigationView,
                                                        modal: modal,
                                                        shouldPreventDismissal: shouldPreventDismissal,
                                                        interceptionExecutionFlow: interceptionExecutionFlow,
                                                        animation: animation)
        }
    }
    
    /// Whether the router can navigate to a given path or not
    /// - Parameter path: Path to navigate to
    /// - Parameter externally: Whether the navigation is coming externally or not
    open func canNavigate(toPath path: String,
                          externally: Bool = false) -> Bool {
        // Check if it is an external url and let the system handle it
        guard path.starts(with: "/") else {
            if let url: URL = URL(string: path), UIApplication.shared.canOpenURL(url) {
                return true
            }
            return false
        }
        
        // Check for a route matching given path
        guard let route: NavigationRoute = Self.routes.first(where: {
            self.path(path.lowercased(), matchesRoutePath: $0.path.lowercased())
        }) else {
            // Let the authentication handler handle callback URL if applicable
            if let callbackUrl: URL = URL(string: path),
                Self.authenticationHandler?.canHandleCallbackUrl?(callbackUrl) ?? false {
                return true
            }
            
            // Non-registered route and given path is not the callback URL for authorization
            return false
        }
        
        // Ensure route can be launched externally if it is coming from a deeplink
        guard !externally || route.allowedExternally else {
            // Do nothing, external navigation not allowed for given path
            return false
        }
        
        // Ensure authentication is available
        guard !route.requiresAuthentication || Self.authenticationHandler != nil else {
            return false
        }
        
        return true
    }
    
    /// Gets view controller for given path
    /// - Parameter path: Path to return view  for
    /// - Returns: UIViewController
    open func viewControllerFor(path: String) -> UIViewController? {
        // Get route
        guard let route: NavigationRoute = Self.routes.first(where: {
            self.path(path.lowercased(), matchesRoutePath: $0.path.lowercased())
        }) else {
            return nil
        }
        
        // Parse parameters
        let parameters: [String: String]? = self.path(path, toDictionaryForRoutePath: route.path)
        
        // Ensure we've got valid parameters
        if !(route.type.requiredParameters?.isEmpty ?? true) {
            guard parameters != nil else {
                return nil
            }
            let givenParametersNames: Set<String> = Set<String>(parameters!.keys)
            
            // Ensure parameters matches required parameters by view model
            let requiredParametersNames: [String] = route.type.requiredParameters ?? []
            for requiredParameter in requiredParametersNames {
                if !givenParametersNames.contains(requiredParameter) {
                    return nil
                }
            }
        }
        
        // Instantiate routable
        let routable: Routable = route.type.init(parameters: parameters)
        
        // Return view controller
        return routable.routedViewController
    }
    
#if canImport(SwiftUI)
    /// Gets view for given path
    /// - Parameter path: Path to return view  for
    /// - Returns: UIViewController
    @available(iOS 13.0, macOS 10.15, *)
    open func viewFor(path: String) -> AnyView {
        let defaultView: AnyView = EmptyView().eraseToAnyView()
        
        // Get route
        guard let route: NavigationRoute = Self.routes.first(where: {
            self.path(path.lowercased(), matchesRoutePath: $0.path.lowercased())
        }) else {
            return defaultView
        }
        
        // Parse parameters
        let parameters: [String: String]? = self.path(path, toDictionaryForRoutePath: route.path)
        
        // Ensure we've got valid parameters
        if !(route.type.requiredParameters?.isEmpty ?? true) {
            guard parameters != nil else {
                return defaultView
            }
            let givenParametersNames: Set<String> = Set<String>(parameters!.keys)
            
            // Ensure parameters matches required parameters by view model
            let requiredParametersNames: [String] = route.type.requiredParameters ?? []
            for requiredParameter in requiredParametersNames {
                if !givenParametersNames.contains(requiredParameter) {
                    return defaultView
                }
            }
        }
        
        // Instantiate routable
        let routable: Routable = route.type.init(parameters: parameters)
        guard let hostingController: UIHostingController<AnyView> =
            routable.routedViewController as? UIHostingController<AnyView> else {
            return defaultView
        }
        
        // Return view
        return hostingController.rootView
    }
#endif
    
    /// Dismisses modal if needed
    open func dismissModalIfNeeded() {
        DispatchQueue.main.async {
            // Get root controller from active scene
            guard let keyWindow: UIWindow = self.keyWindow,
                let rootViewController = keyWindow.rootViewController else {
                    return
            }
            
            rootViewController.presentedViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    /// Pop VC if needed
    open func popViewController(animated: Bool = true) {
        DispatchQueue.main.async { [self] in
            // Get root controller from active scene
            guard let keyWindow: UIWindow = self.keyWindow,
                let rootViewController = keyWindow.rootViewController else {
                    return
            }
            let topRootViewController: UIViewController = rootViewController.presentedViewController ?? rootViewController
           
            if let tabBarController: UITabBarController = self.getFindController(in: topRootViewController),
                     let selectedVC = tabBarController.selectedViewController,
                     let navigationController: UINavigationController = self.getFindController(in: selectedVC) {
                navigationController.popViewController(animated: animated)
            } else if let navigationController: UINavigationController = self.getFindController(in: topRootViewController) {
                navigationController.popViewController(animated: animated)
           }
        }
    }
}
