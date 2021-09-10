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

#if canImport(SwiftUI)
import SwiftUI

/// Routable view model
@MainActor public protocol RoutableViewModel: Routable {
    /// Routed view
    @available(iOS 13.0, macOS 10.15, *)
    nonisolated var routedView: AnyView { get }
}

/// Routable view model
public extension RoutableViewModel {
    /// Routed view
    @available(iOS 13.0, macOS 10.15, *)
    var routedView: AnyView {
        EmptyView()
            .eraseToAnyView()
    }
    
    /// Routed view controller
    @available(iOS 13.0, macOS 10.15, *)
    var routedViewController: UIViewController {
        UIHostingController(rootView: self.routedView)
    }
}

/// Routable view
@available(iOS 13.0, macOS 10.15, *)
@MainActor public protocol RoutableView where Self: View {
    // MARK: - Associated types
    
    /// View model type
    associatedtype ViewModel: RoutableViewModel
    
    // MARK: - Fields
    
    /// View model instance
    var viewModel: ViewModel { get }
}
#endif

#if canImport(UIKit)
import UIKit

/// Routable view controller
public protocol RoutableViewController where Self: UIViewController {
    // MARK: - Associated types
    
    /// View model type
    associatedtype ViewModel: RoutableViewModel
    
    // MARK: - Fields
    
    /// View model instance
    var viewModel: ViewModel! { get }
}
#endif
