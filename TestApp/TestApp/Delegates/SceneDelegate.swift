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
import NavigationRouter

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    class MockedAuthenticationHandler: RouterAuthenticationHandler {
        var authenticationRequested: Bool = false
        
        var isAuthenticated: Bool {
            return authenticationRequested
        }
        
        func login(completion: (() -> Void)?) {
            DispatchQueue.main.async {
                let alert: UIAlertController = UIAlertController(title: "Login", message: "Login successful", preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .default, handler: { _ in
                    self.authenticationRequested = true
                    DispatchQueue.global().async {
                        completion?()
                    }
                }))
                
                guard let keyWindow: UIWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first,
                    let rootViewController = keyWindow.rootViewController else {
                        // TODO: Handle error here
                        return
                }
                rootViewController.present(alert, animated: true, completion: nil)
            }
        }
        
        func logout(completion: (() -> Void)?) {
            
        }
        
        func canHandleCallbackUrl(_ url: URL) -> Bool {
            return false
        }
        
        func handleCallbackUrl(_ url: URL) {
            
        }
    }
    
    class MockedErrorHandler: RouterErrorHandler {
        func handleError(_ error: RoutingError) {
            DispatchQueue.main.async {
                let alert: UIAlertController = UIAlertController(title: "Error", message: "Navigation error", preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .default, handler: nil))
                
                guard let keyWindow: UIWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first,
                    let rootViewController = keyWindow.rootViewController else {
                        // TODO: Handle error here
                        return
                }
                rootViewController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Create mocked authentication handler for router
        NavigationRouter.authenticationHandler = MockedAuthenticationHandler()
        NavigationRouter.errorHandler = MockedErrorHandler()
        
        // Create the SwiftUI view that provides the window contents.
        guard let contentView: UIViewController = NavigationRouter.main.viewControllerFor(path: "/view1A") else {
            return
        }

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = contentView
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        // Ensure we've got a valid URL
        guard let url = URLContexts.first?.url else {
            return
        }
        
        // Let the router handle external navigations
        if url.scheme == "routertestapp", url.relativePath.starts(with: "/navigate") {
            DispatchQueue.global().async {
                NavigationRouter.main.navigate(toPath: url.relativePath.replacingOccurrences(of: "/navigate", with: ""), externally: true)
            }
        }
    }
}
