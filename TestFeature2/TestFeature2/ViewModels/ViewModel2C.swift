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

import NavigationRouter
import SwiftUI

/// Routable view model
struct ViewModel2C: RoutableViewModel {
    var navigationInterceptionExecutionFlow: NavigationInterceptionFlow?
    
    // MARK: - Static fields
    
    /// Required parameters
    static var requiredParameters: [String]? {
        return [
            "id",
            "show"
        ]
    }
    
    // MARK: - Fields
    
    /// Identifier (parameter)
    var id: String?
    var show: Bool?
    
    // MARK: - Initializers
    
    /// Initializes a new instance with given parameters
    /// - Parameter parameters: Parameters used for navigation
    init(parameters: [String : String]?) {
        self.id = parameters?["id"]
        let show = parameters?["show"] ?? "false"
        self.show = Bool(show)
    }
    
    // MARK: - View builder
    
    /// Makes view for navigation
    var routedView: AnyView {
        View2C(viewModel: self)
            .eraseToAnyView()
    }
}
