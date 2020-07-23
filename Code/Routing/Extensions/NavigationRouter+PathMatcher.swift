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

// MARK: - Path matcher
extension NavigationRouter {
    /// Gets whether given path matches given route path
    /// - Parameters:
    ///   - path: Path to be compared
    ///   - routePath: Route path
    func path(_ path: String, matchesRoutePath routePath: String) -> Bool {
        // Create patch matcher instance
        let pathMatcher: PathMatcher = PathMatcher(match: routePath, exact: true)
        
        // Invoke matching method
        return pathMatcher.matches(path)
    }
    
    /// Gets dictionary parameters from given path
    /// - Parameters:
    ///   - path: Path
    ///   - toDictionaryForRoutePath: Route path
    func path(_ path: String, toDictionaryForRoutePath routePath: String) -> [String: String]? {
        // Make sure route matches
        guard self.path(path, matchesRoutePath: routePath) else {
            return nil
        }
        
        // Instantiate matcher
        let pathMatcher: PathMatcher = PathMatcher(match: routePath, exact: true)
        
        // Parse parameters
        return try? pathMatcher.execute(path: path)
    }
}
