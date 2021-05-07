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

import SwiftUI
import NavigationRouter

/// View 1A
struct View1A: RoutableView {
    // MARK: - View body
    
    /// Body builder
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("This is the root view, set as root view controller for active scene using UIHostingController.")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("In-module navigation")
                            .font(.headline)
                        
                        RoutedLink(to: "/view1B") {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Navigate to View 1B")
                                        .bold()
                                        .foregroundColor(Color(UIColor.systemBackground))
                                        .accessibility(identifier: "testNavigationInSameModuleWithoutAuthentication")
                                    
                                    Text("(without authentication)")
                                        .font(.footnote)
                                        .foregroundColor(Color(UIColor.systemBackground))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(UIColor.systemBackground))
                            }
                            .padding()
                        }
                        .background(Color.primary)
                        .cornerRadius(4)
                        
                        RoutedLink(to: "/view1C") {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text("Navigate to View 1C")
                                            .bold()
                                            .foregroundColor(Color(UIColor.systemBackground))
                                            .accessibility(identifier: "testNavigationInSameModuleWithAuthentication")
                                            
                                        Spacer()
                                    }
                                    
                                    Text("(with authentication)")
                                        .font(.footnote)
                                        .foregroundColor(Color(UIColor.systemBackground))
                                }
                                    
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(UIColor.systemBackground))
                            }
                            .padding()
                        }
                        .background(Color.primary)
                        .cornerRadius(4)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Cross-module navigation")
                            .font(.headline)
                        
                        RoutedLink(to: "/view2A") {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Navigate to View 2A")
                                        .bold()
                                        .foregroundColor(.white)
                                        .accessibility(identifier: "testNavigationBetweenModulesWithoutAuthentication")
                                    
                                    Text("(without authentication)")
                                        .font(.footnote)
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(UIColor.systemBackground))
                            }
                            .padding()
                        }
                        .background(Color.blue)
                        .cornerRadius(4)
                        
                        RoutedLink(to: "/view2B") {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Navigate to View 2B")
                                        .bold()
                                        .foregroundColor(.white)
                                        .accessibility(identifier: "testNavigationBetweenModulesWithAuthentication")
                                    
                                    Text("(with authentication)")
                                        .font(.footnote)
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(UIColor.systemBackground))
                            }
                            .padding()
                        }
                        .background(Color.blue)
                        .cornerRadius(4)
                    }
                    
                    Divider()
                        
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Parametrized navigation")
                            .font(.headline)
                        
                        RoutedLink(to: "/view2C/:id=5:show=true") {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Navigate to View 2C")
                                        .bold()
                                        .foregroundColor(.white)
                                        .accessibility(identifier: "testNavigationBetweenModulesWithParameters")
                                    
                                    Text("(with parameters)")
                                        .font(.footnote)
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(UIColor.systemBackground))
                            }
                            .padding()
                        }
                        .background(Color.red)
                        .cornerRadius(4)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Intercepting navigation")
                            .font(.headline)
                        
                        RoutedLink(to: "/view2D") {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Navigate to View 2D")
                                        .bold()
                                        .foregroundColor(.white)
                                        .accessibility(identifier: "testInterceptionAfterNavigation")
                                        
                                    Text("(after navigation)")
                                        .font(.footnote)
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(UIColor.systemBackground))
                            }
                            .padding()
                        }
                        .background(Color.purple)
                        .cornerRadius(4)
                        
                        RoutedLink(to: "/view2E") {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Navigate to View 2E")
                                        .bold()
                                        .foregroundColor(.white)
                                        .accessibility(identifier: "testInterceptionBeforeNavigation")
                                    
                                    Text("(before navigation)")
                                        .font(.footnote)
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(UIColor.systemBackground))
                            }
                            .padding()
                        }
                        .background(Color.purple)
                        .cornerRadius(4)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Navigation stack handling")
                            .font(.headline)
                        
                        RoutedLink(to: "/view3A") {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Navigate to View 3A")
                                        .bold()
                                        .foregroundColor(.white)
                                        .accessibility(identifier: "testMultipleNavigations1")
                                    
                                    Text("(multiple navigations)")
                                        .font(.footnote)
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(UIColor.systemBackground))
                            }
                            .padding()
                        }
                        .background(Color(UIColor.brown))
                        .cornerRadius(4)
                    }
                }
                .padding()
            }.navigationBarTitle("View 1A", displayMode: .large)
        }
    }
    
    // MARK: - Fields
    
    /// View model instance
    var viewModel: ViewModel1A
    
    // MARK: - Initializers
    
    /// Initializes a new instance with given view model
    /// - Parameter viewModel: View model instance
    init(viewModel: ViewModel1A) {
        self.viewModel = viewModel
    }
}
