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
// swiftlint:disable vertical_whitespace_between_cases

/// Routing errors
public enum RoutingError: Error {
    /// Unauthorized
    case unauthorized
    
    /// Non-registered route
    case nonRegisteredRoute(path: String)
    
    /// Inactive scene
    case inactiveScene
    
    /// Missing parameters
    case missingParameters(message: String = "")
    
    case unknown(msg: String = "")
}

extension RoutingError: LocalizedError {
   public var localizedDescription: String {
        switch self {
        case .missingParameters(let msg):
            return NSLocalizedString(msg, comment: "RoutingError")
        case .unauthorized:
            return NSLocalizedString("For access, the user must be registered", comment: "RoutingError")
        case .nonRegisteredRoute(let msg):
            return NSLocalizedString("unregistered path, please check the path: \(msg)", comment: "RoutingError")
        case .inactiveScene:
            return NSLocalizedString("Inactive scene", comment: "RoutingError")
        case .unknown(let msg):
            return NSLocalizedString(msg, comment: "RoutingError")
        }
    }
}
