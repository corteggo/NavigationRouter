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

import XCTest
import Nimble

@testable import NavigationRouterTestApp
@testable import NavigationRouter
@testable import TestFeature1
@testable import TestFeature2
@testable import TestFeature3

/// Navigation router tests
final class NavigationRouterTests: XCTestCase {
    // MARK: - Inner classes
    
    /// Mocked authentication handler
    class MockedAuthenticationHandler: RouterAuthenticationHandler {
        var authenticationRequested: Bool = false
        
        var isAuthenticated: Bool {
            return authenticationRequested
        }
        
        func login(completion: (() -> Void)?) {
            DispatchQueue.global().async {
                self.authenticationRequested = true
                
                DispatchQueue.global().async {
                    completion?()
                }
            }
        }
        
        func logout(completion: (() -> Void)?) {
            // Unsupported method
        }
        
        func canHandleCallbackUrl(_ url: URL) -> Bool {
            return false
        }
        
        func handleCallbackUrl(_ url: URL) {
            // Unsupported method
        }
    }
    
    /// Mocked error handler
    class MockedErrorHandler: RouterErrorHandler {
        var errorCompletion: (() -> Void)?
        
        func handleError(_ error: RoutingError) {
            errorCompletion?()
        }
    }
    
    // MARK: - Fields
    
    /// Navigation router
    private let router: NavigationRouter = NavigationRouter.main
    
    // MARK: - Navigation binding
    
    /// Tests route binding
    func testRouteBinding() {
        // Declare test route
        let testNavigationRoute: NavigationRoute = NavigationRoute(path: "testPath", type: ViewModel1A.self)
        
        // Bind route
        NavigationRouter.bind(route: testNavigationRoute)
        
        // Expect route to be binded
        expect(NavigationRouter.routes).to(contain(testNavigationRoute))
    }
    
    /// Tests route unbinding
    func testRouteUnbinding() {
        // Declare test route
        let testNavigationRoute: NavigationRoute = NavigationRoute(path: "testPath", type: ViewModel1A.self)
        
        // Bind route
        NavigationRouter.bind(route: testNavigationRoute)
        
        // Unbind route
        NavigationRouter.unbind(route: testNavigationRoute)
        
        // Expect route to be binded
        expect(NavigationRouter.routes).toNot(contain(testNavigationRoute))
    }
    
    // MARK: - Error handling
    
    /// Tests navigation to non-registered route
    func testNavigationToNonRegisteredRoute() {
        // Create mocked handlers
        let mockedAuthenticationHandler: MockedAuthenticationHandler = MockedAuthenticationHandler()
        let mockedErrorHandler: MockedErrorHandler = MockedErrorHandler()
        
        // Prepare completion for testing
        let expectation: XCTestExpectation = XCTestExpectation()
        mockedErrorHandler.errorCompletion = {
            expectation.fulfill()
        }
        
        // Register error handler
        NavigationRouter.authenticationHandler = mockedAuthenticationHandler
        NavigationRouter.errorHandler = mockedErrorHandler
        
        // Navigate to a non-registered route
        self.router.navigate(toPath: "/invented/path")
        
        // Wait for expectations
        wait(for: [expectation], timeout: 1)
    }
    
    /// Tests mismatching parameters
    func testMismatchingParameters() {
        // Ensure routing with mismatching parameters causes an error
        let mockedErrorHandler: MockedErrorHandler = MockedErrorHandler()
        
        // Create expectation
        let expectation: XCTestExpectation = XCTestExpectation()
        
        // Prepare completion for testing
        mockedErrorHandler.errorCompletion = {
            expectation.fulfill()
        }
        
        // Register error handler
        NavigationRouter.errorHandler = mockedErrorHandler
        
        // Navigate with wrong parameters
        self.router.navigate(toPath: "/view2C")
        
        // Ensure error handled
        wait(for: [expectation], timeout: 1)
    }
}
