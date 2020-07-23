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

/// Routable protocol
public protocol Routable {
    // MARK: - Static fields
    
    /// Required parameters
    static var requiredParameters: [String]? { get }
    
    // MARK: - Fields
    
    /// Navigation interception flow (if any)
    var navigationInterceptionExecutionFlow: NavigationInterceptionFlow? { get set }
    
    // MARK: - Initializers
    
    /// Initializes a new instance with given parameters
    /// - Parameter parameters: Parameters provided by router
    init(parameters: [String: String]?)
    
    // MARK: - View
    
    /// Routed view
    var routedViewController: UIViewController { get }
}

#if canImport(SwiftUI)
import SwiftUI
@available(iOS 13.0, macOS 10.15, *)
public extension Routable where Self: View {
    /// Routed view
    var routedViewController: UIViewController {
        UIHostingController(rootView: self.eraseToAnyView())
    }
}
#endif

#if canImport(UIKit)
import UIKit
public extension Routable where Self: UIViewController {
    /// Initializes a new instance with given data
    /// - Parameters:
    ///   - nibNameOrNil: Nib name (or nil)
    ///   - nibBundleOrNil: Nib bundle (or nil)
    ///   - parameters: Navigation parameters
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, parameters: [String: String]?) {
        self.init(parameters: parameters)
        self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /// Initializes a new instance with given data
    /// - Parameters:
    ///   - coder: Coder isntance
    ///   - parameters: Navigation parameters
    init?(coder: NSCoder, parameters: [String: String]?) {
        self.init(parameters: parameters)
        self.init(coder: coder)
    }
    
    /// Routed view
    var routedViewController: UIViewController {
        self
    }
}
#endif
