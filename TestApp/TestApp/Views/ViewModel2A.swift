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
struct ViewModel2A: RoutableViewModel {
    var navigationInterceptionExecutionFlow: NavigationInterceptionFlow?
    
    static var requiredParameters: [String]? {
        return nil
    }
    
    init(parameters: [String : String]?) {
        
    }
    
    var view: UIViewController {
        return View2A(viewModel: self).asUIViewController()
    }
}
