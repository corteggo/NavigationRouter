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

import SwiftUI
import NavigationRouter

/// Sample view for testing purposes
struct View1A: RoutableView {
    // MARK: - Fields
    
    /// View model
    var viewModel: ViewModel1A
    
    // MARK: - Initializers
    
    /// Initializes a new instance with given view model
    /// - Parameter viewModel: View model instance
    init(viewModel: ViewModel1A) {
        self.viewModel = viewModel
    }
    
    // MARK: - View builder
    
    /// View body
    public var body: some View {
        VStack {
            Text("This is the root view")
            
            Spacer()
            
            VStack {
                RoutedLink(to: "/view1b") {
                    Text("Navigate in-module without authentication")
                        .accessibility(identifier:
                            "testNavigationInSameModuleWithoutAuthentication")
                }
                RoutedLink(to: "/view1c") {
                    Text("Navigate in-module with authentication")
                        .accessibility(identifier:
                            "testNavigationInSameModuleWithAuthentication")
                }
            }
            
            VStack {
                RoutedLink(to: "/view2a") {
                    Text("Navigate between modules without authentication")
                        .accessibility(identifier:
                            "testNavigationBetweenModulesWithoutAuthentication")
                }
                RoutedLink(to: "/view2b") {
                    Text("Navigate between modules with authentication")
                        .accessibility(identifier:
                            "testNavigationBetweenModulesWithAuthentication")
                }
                RoutedLink(to: "/view2c/5") {
                    Text("Navigate between modules with parameters")
                        .accessibility(identifier:
                            "testNavigationBetweenModulesWithParameters")
                }
                RoutedLink(to: "/view2d") {
                    Text("Navigate with interception (after)")
                        .accessibility(identifier:
                            "testInterceptionAfterNavigation")
                }
                RoutedLink(to: "/view2e") {
                    Text("Navigate with interception (before)")
                        .accessibility(identifier:
                            "testInterceptionBeforeNavigation")
                }
            }
            
            VStack {
                RoutedLink(to: "/view3a") {
                    Text("Navigate to View3A")
                        .accessibility(identifier: "testView3A")
                }
            }
            
            Spacer()
        }.navigationBarTitle("Module 1 - Root view")
    }
}
