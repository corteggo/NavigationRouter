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

// MARK: - Private helpers
extension NavigationRouter {
    /// Checks navigation requirements and navigates to given path
    /// - Parameter path: Path to navigate to
    /// - Parameter replace: Whether to replace the stack or not
    /// - Parameter externally: Whether the navigation was launched externally or not
    /// - Parameter embedInNavigationView: Whether to embed the view in a NavigationView or not
    /// - Parameter modal: Whether to present the view as modal or not
    /// - Parameter shouldPreventDismissal: Whether modal dismissal should be prevented or not
    /// - Parameter interceptionExecutionFlow: Navigation interception execution flow (if any)
    /// - Parameter animation: Animation to use for navigation
    func checkNavigationRequirementsAndNavigate(
        toPath path: String,
        replace: Bool,
        externally: Bool,
        embedInNavigationView: Bool = true,
        modal: Bool = false,
        shouldPreventDismissal: Bool = false,
        interceptionExecutionFlow: NavigationInterceptionFlow? = nil,
        animation: NavigationTransition? = nil) {
        // Check if it is an external url and let the system handle it
        guard path.starts(with: "/") else {
            DispatchQueue.main.async {
                if let url: URL = URL(string: path), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            return
        }
        
        // Check for a route matching given path
        guard let route: NavigationRoute = Self.routes.first(where: {
            self.path(path.lowercased(), matchesRoutePath: $0.path.lowercased())
        }) else {
            // Let the authentication handler handle callback URL if applicable
            if let callbackUrl: URL = URL(string: path),
               Self.authenticationHandler?.canHandleCallbackUrl?(callbackUrl) ?? false,
               Self.authenticationHandler?.handleCallbackUrl != nil {
                DispatchQueue.global().async {
                    Self.authenticationHandler?.handleCallbackUrl?(callbackUrl)
                }
                return
            }
            
            // Non-registered route and given path is not the callback URL for authorization
            self.handleError(forPath: path, .nonRegisteredRoute(path: path))
            return
        }
        
        // Ensure route can be launched externally if it is coming from a deeplink
        guard !externally || route.allowedExternally else {
            // Do nothing, external navigation not allowed for given path
            return
        }
        
        // Parse parameters and navigate
        self.parseParametersAndNavigate(toRoute: route,
                                        withPath: path,
                                        replace: replace,
                                        externally: externally,
                                        embedInNavigationView: embedInNavigationView,
                                        modal: modal,
                                        shouldPreventDismissal: shouldPreventDismissal,
                                        interceptionExecutionFlow: interceptionExecutionFlow,
                                        animation: animation)
    }
    
    /// Parses parameters and navigates
    /// - Parameters:
    /// - Parameter route: Route to navigate to
    /// - Parameter path: Path to navigate to
    /// - Parameter replace: Whether to replace the stack or not
    /// - Parameter externally: Whether the navigation was launched externally or not
    /// - Parameter embedInNavigationView: Whether to embed the view in a NavigationView or not
    /// - Parameter modal: Whether to present the view as modal or not
    /// - Parameter shouldPreventDismissal: Whether modal dismissal should be prevented or not
    /// - Parameter interceptionExecutionFlow: Navigation interception execution flow (if any)
    /// - Parameter animation: Animation to use for navigation
    func parseParametersAndNavigate(
        toRoute route: NavigationRoute,
        withPath path: String,
        replace: Bool,
        externally: Bool,
        embedInNavigationView: Bool = true,
        modal: Bool = false,
        shouldPreventDismissal: Bool = false,
        interceptionExecutionFlow: NavigationInterceptionFlow? = nil,
        animation: NavigationTransition? = nil) {
        
        do {
            // Parse parameters
            let parameters: [String: String]? = try self.path(path.lowercased(),
                                                              toDictionaryForRoutePath: route.path.lowercased())
            // Actually navigate to route
            self.navigate(toRoute: route,
                          withParameters: parameters,
                          originalPath: path,
                          replace: replace,
                          externally: externally,
                          embedInNavigationView: embedInNavigationView,
                          modal: modal,
                          shouldPreventDismissal: shouldPreventDismissal,
                          interceptionExecutionFlow: interceptionExecutionFlow,
                          animation: animation)
        } catch let error as RoutingError {
            self.handleError(forPath: path, error)
        } catch {
            self.handleError(forPath: path, .unknown(msg: "unknown error on Parses parameters and navigates"))
        }
    }
    
    /// Navigates to given route with given parameters
    /// - Parameters:
    ///   - route: Route to navigate to
    ///   - parameters: Parameters to use for navigation
    ///   - originalPath: Original navigation path
    ///   - replace: Whether to replace the stack or not
    ///   - externally: Whether the navigation is coming from an external source or not
    ///   - embedInNavigationView: Whether to embed the navigated view into a NavigationView
    ///   - modal: Whether to show the navigated view as modal or not
    ///   - shouldPreventDismissal: Whether modal dismissal should be prevented or not
    ///   - ignoreInterceptorsBefore: Whether to ignore interceptors before navigating or not
    ///   - interceptionExecutionFlow: Navigation interception execution flow (if any)
    ///   - animation: Animation to use for navigation
    func navigate(
        toRoute route: NavigationRoute,
        withParameters parameters: [String: String]?,
        originalPath: String,
        replace: Bool = false,
        externally: Bool = false,
        embedInNavigationView: Bool = true,
        modal: Bool = false,
        shouldPreventDismissal: Bool = false,
        ignoreInterceptorsBefore: Bool = false,
        interceptionExecutionFlow: NavigationInterceptionFlow? = nil,
        animation: NavigationTransition? = nil) {
        
        // Declare actual navigation flow
        let actualNavigationFlow: (() -> Void) = {
            // Always execute this on main thread since it is UI-related
            DispatchQueue.main.asyncAfter(deadline: .now() + (externally ? Self.externalNavigationDelay : 0), execute: {
                self.instantiateViewControllerAndNavigate(toRoute: route,
                                                          withParameters: parameters,
                                                          originalPath: originalPath,
                                                          replace: replace,
                                                          embedInNavigationView: embedInNavigationView,
                                                          modal: modal,
                                                          shouldPreventDismissal: shouldPreventDismissal,
                                                          interceptionExecutionFlow: interceptionExecutionFlow,
                                                          animation: animation)
            })
        }
        
        // Check whether previous interceptors must be ignored or not
        guard !ignoreInterceptorsBefore else {
            actualNavigationFlow()
            return
        }
        
        // Let interceptors do their work before actually navigating to the original requested path
        self.routerWillNavigate(toRoute: route,
                                withParameters: parameters,
                                originalPath: originalPath,
                                replace: replace,
                                embedInNavigationView: embedInNavigationView,
                                modal: modal,
                                shouldPreventDismissal: shouldPreventDismissal,
                                animation: animation,
                                completion: actualNavigationFlow)
    }
    
    /// Instantiates view controller and navigates
    /// - Parameters:
    ///   - route: Route to navigate to
    ///   - parameters: Parameters to use for navigation
    ///   - originalPath: Original navigation path
    ///   - replace: Whether to replace the stack or not
    ///   - embedInNavigationView: Whether to embed the navigated view into a NavigationView
    ///   - modal: Whether to show the navigated view as modal or not
    ///   - shouldPreventDismissal: Whether modal dismissal should be prevented or not
    ///   - interceptionExecutionFlow: Navigation interception execution flow (if any)
    ///   - animation: Animation to use for navigation
    // swiftlint:disable:next function_body_length cyclomatic_complexity
    func instantiateViewControllerAndNavigate(
        toRoute route: NavigationRoute,
        withParameters parameters: [String: String]?,
        originalPath: String,
        replace: Bool = false,
        embedInNavigationView: Bool = true,
        modal: Bool = false,
        shouldPreventDismissal: Bool = false,
        interceptionExecutionFlow: NavigationInterceptionFlow? = nil,
        animation: NavigationTransition? = nil) {
        // Check for authentication level
        guard !route.requiresAuthentication || Self.isUserAuthenticated else {
            guard let authenticationHandler: RouterAuthenticationHandler = Self.authenticationHandler else {
                self.handleError(forPath: originalPath, .unauthorized)
                return
            }
            
            self.dispatchQueue.async {
                authenticationHandler.login(completion: {
                    self.dispatchQueue.async {
                        self.navigate(toPath: originalPath,
                                      replace: replace,
                                      embedInNavigationView: embedInNavigationView,
                                      modal: modal,
                                      shouldPreventDismissal: shouldPreventDismissal,
                                      interceptionExecutionFlow: interceptionExecutionFlow,
                                      animation: animation)
                    }
                })
            }
            return
        }
        
        // Instantiate view model
        var viewModel = route.type.init(parameters: parameters)
        
        // Set navigation interception execution flow (if any)
        viewModel.navigationInterceptionExecutionFlow = interceptionExecutionFlow
        
        // Get root controller from active scene
        guard let keyWindow: UIWindow = self.keyWindow,
              let rootViewController = keyWindow.rootViewController else {
            self.handleError(forPath: originalPath, .inactiveScene)
            return
        }
        
        // Choose modal view controller (if any) instead of root view
        // to be able to navigate in modals
        let topRootViewController: UIViewController = rootViewController.presentedViewController ?? rootViewController
        
        // Create a hosting controller for instantiated view
        let hostedViewController: UIViewController = viewModel.routedViewController
        #if DEBUG
        hostedViewController.view.accessibilityIdentifier = originalPath
        #endif
        
        // Push hosted view
        if modal {
            let modalViewController: UIViewController =
                embedInNavigationView ? UINavigationController(rootViewController: hostedViewController)
                : hostedViewController
            if #available(iOS 13.0, macOS 10.15, *) {
                modalViewController.isModalInPresentation = shouldPreventDismissal
            }
            
            keyWindow.rootViewController?.present(
                modalViewController,
                animated: true,
                completion: nil)
        } else if replace {
            if embedInNavigationView, !(hostedViewController is UITabBarController) {
                self.setRootViewController(forWindow: keyWindow,
                                           UINavigationController(rootViewController: hostedViewController),
                                           animation: animation)
            } else {
                self.setRootViewController(forWindow: keyWindow, hostedViewController, animation: animation)
            }
        } else if let tabBarController: UITabBarController = getController(in: topRootViewController),
                  let selectedVC = tabBarController.selectedViewController,
                  let navigationController: UINavigationController = getController(in: selectedVC) {
            navigationController.pushViewController(hostedViewController, animated: true)
        } else if let navigationController: UINavigationController = getController(in: topRootViewController) {
            navigationController.pushViewController(hostedViewController, animated: true)
        } else if embedInNavigationView {
            self.setRootViewController(forWindow: keyWindow,
                                       UINavigationController(rootViewController: hostedViewController),
                                       animation: animation)
        } else {
            self.setRootViewController(forWindow: keyWindow, hostedViewController, animation: animation)
        }
        
        Self.globalInterceptor?.interceptor(route: route.path)
        // Let post-navigation interceptors do their work
        DispatchQueue.main.async {
            self.routerDidNavigate(toRoute: route,
                                   withParameters: parameters,
                                   originalPath: originalPath,
                                   replace: replace,
                                   embedInNavigationView: embedInNavigationView,
                                   modal: modal,
                                   shouldPreventDismissal: shouldPreventDismissal,
                                   animation: animation)
        }
    }
    
    /// Sets root view controller
    /// - Parameters:
    ///   - window: UIWindow instance
    ///   - viewController: UIViewController instance
    ///   - animation: Animation to use for transition
    private func setRootViewController(
        forWindow window: UIWindow,
        _ viewController: UIViewController,
        animation: NavigationTransition? = .left) {
        // Ensure we've got a valid animation, otherwise change it immediately
        guard animation != nil, animation != .some(.none) else {
            window.rootViewController = viewController
            return
        }
        
        var transitionOptions: UIWindow.TransitionOptions?
        switch animation {
        case .right:
            transitionOptions = .init(direction: .toLeft, style: .easeInOut)
            
        case .down:
            transitionOptions = .init(direction: .toBottom, style: .easeInOut)
            
        case .up:
            transitionOptions = .init(direction: .toTop, style: .easeInOut)
            
        default: // left
            transitionOptions = .init(direction: .toRight, style: .easeInOut)
        }
        
        if transitionOptions != nil {
            window.setRootViewController(viewController,
                                         options: transitionOptions!)
        }
    }
}
