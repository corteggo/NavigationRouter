//
// ©2019 SEAT, S.A. All rights reserved.
//
// This is file is part of a propietary app or framework.
// Unauthorized reproduction, copying or modification of this file is strictly prohibited.
//
// This code is proprietary and confidential.
//
// All the 3rd-party libraries included in the project are regulated by their own licenses.
//

import NavigationRouter
import UIKit

/// Routable view model
struct ViewModel1A: RoutableViewModel {
    // MARK: - Fields
    
    /// Required parameters
    static var requiredParameters: [String]? {
        return nil
    }
    
    /// Navigation interception execution flow
    var navigationInterceptionExecutionFlow: NavigationInterceptionFlow?
    
    // MARK: - Initializers
    
    init(parameters: [String : String]?) {
        
    }
    
    // MARK: - View builder
    
    /// View body
    var view: UIViewController {
        return View1A(viewModel: self)
            .asUIViewController()
    }
}
