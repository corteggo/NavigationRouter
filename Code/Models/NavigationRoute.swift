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

/// Navigation route
public struct NavigationRoute: Route {
    /// Path
    public var path: String
    
    /// Whether the route requires authentication or not, defaults to true
    public var requiresAuthentication: Bool
    
    /// View
    public var type: Routable.Type
    
    /// Whether the route is allowed externally or not
    public var allowedExternally: Bool
    
    // MARK: - Initializers
    
    /// Initializes a new instance with given data
    /// - Parameters:
    ///   - path: Path for navigation route (with wildcards for parameters)
    ///   - type: Any instance conforming to Routable
    ///   - requiresAuthentication: Whether the route requires authentication or not
    ///   - allowedExternally: Whether the route is allowed ot be launched externally or not
    public init(path: String,
                type: Routable.Type,
                requiresAuthentication: Bool = true,
                allowedExternally: Bool = false) {
        self.path = path.lowercased()
        self.type = type
        self.requiresAuthentication = requiresAuthentication
        self.allowedExternally = allowedExternally
    }
    
    // MARK: - Equatable
    
    /// Gets whether two given instances are equal or not
    /// - Parameters:
    ///   - lhs: First instance to compare
    ///   - rhs: Second instance to compare
    public static func == (lhs: NavigationRoute, rhs: NavigationRoute) -> Bool {
        return lhs.path == rhs.path
    }
    
    // MARK: - Hashable
    
    /// Hashes this instance into given hasher
    /// - Parameter hasher: Hasher instance
    public func hash(into hasher: inout Hasher) {
        hasher.combine(path)
    }
}
