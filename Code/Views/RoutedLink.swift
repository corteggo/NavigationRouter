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

#if canImport(SwiftUI)
import SwiftUI
#endif

/// Routed link
@available(iOS 13.0, macOS 10.15, *)
public struct RoutedLink<Label: SwiftUI.View>: SwiftUI.View {
    // MARK: - Fields
    
    /// Navigation Router
    private let router: Router
    
    /// Path to navigate to
    private let path: String
    
    /// Whether to replace navigation stack upon navigation or not
    private let replace: Bool
    
    /// Whether to embed destination path in a navigation view or not
    private let embedInNavigationView: Bool
    
    /// Whether to use a modal presentation style for destination view or not
    private let modal: Bool
    
    /// Whether to prevent modal dismissal or not
    private let shouldPreventDismissal: Bool
    
    /// Navigation interception execution flow (if any)
    private let interceptionExecutionFlow: NavigationInterceptionFlow?
    
    /// Transition animation
    private let animation: NavigationTransition?
    
    /// View contents
    private let label: Label
    
    // MARK: - Initializers
    
    /// Initializes a new instance for given path
    /// - Parameters:
    ///   - path: Path to navigate to
    ///   - replace: Whether to replace navigation stack or not
    ///   - embedInNavigationView: Whether to embed destination view in a navigation view or not
    ///   - modal: Whether to use modal presentation style for destination view or not
    ///   - shouldPreventDismissal: Whether the presented modal should prevent dismissal or not
    ///   - interceptionExecutionFlow: Navigation interception execution flow (if any)
    ///   - animation: Navigation transition (if any)
    ///   - router: Router (if any)
    ///   - label: View contents
    public init(to path: String,
                replace: Bool = false,
                embedInNavigationView: Bool = true,
                modal: Bool = false,
                shouldPreventDismissal: Bool = false,
                interceptionExecutionFlow: NavigationInterceptionFlow? = nil,
                animation: NavigationTransition? = nil,
                router: Router = NavigationRouter.main,
                @ViewBuilder label: () -> Label) {
        self.path = path
        self.replace = replace
        self.embedInNavigationView = embedInNavigationView
        self.modal = modal
        self.shouldPreventDismissal = shouldPreventDismissal
        self.interceptionExecutionFlow = interceptionExecutionFlow
        self.animation = animation
        self.router = router
        self.label = label()
    }
    
    // MARK: - Body builder
    
    /// View body
    public var body: some SwiftUI.View {
        label.onTapGesture {
            DispatchQueue.main.async {
                // Navigate to given path
                self.router.navigate(
                    toPath: self.path,
                    replace: self.replace,
                    externally: false,
                    embedInNavigationView: self.embedInNavigationView,
                    modal: self.modal,
                    shouldPreventDismissal: self.shouldPreventDismissal,
                    interceptionExecutionFlow: self.interceptionExecutionFlow,
                    animation: self.animation)
            }
        }
    }
}
