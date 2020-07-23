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

public struct View3E: RoutableView {
    public var body: some SwiftUI.View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("This is the fifth view of Module 3.")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text("It is used as an interceptor for View 2E.")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Continue")
                            .bold()
                            .foregroundColor(.white)
                            .accessibility(identifier: "testContinueInterceptor")
                        
                        Text("(to View 2E)")
                            .font(.footnote)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(UIColor.systemBackground))
                }
                .padding()
                .background(Color(UIColor.brown))
                .cornerRadius(4)
                .onTapGesture {
                    // Continue original navigation flow
                    self.viewModel
                        .navigationInterceptionExecutionFlow?
                        .continue?(false)
                }
            }
            .padding()
        }
        .navigationBarTitle("View 3E", displayMode: .large)
    }
    
    public var viewModel: ViewModel3E
    
    public init(viewModel: ViewModel3E) {
        self.viewModel = viewModel
    }
}
