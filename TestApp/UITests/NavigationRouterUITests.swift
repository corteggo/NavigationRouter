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

/// Navigation router UI tests
final class NavigationRouterUITests: XCTestCase {
    // MARK: - Fields
    
    /// Navigation router
    private let router: NavigationRouter = NavigationRouter.main
    
    // MARK: - Set up
    
    /// Setups test case
    override func setUp() {
        super.setUp()
        
        // Do not continue after failure
        self.continueAfterFailure = false
        
        // Create app instance
        let app: XCUIApplication = XCUIApplication()
        
        // Launch app before each test execution
        app.launch()
    }
    
    // MARK: - Navigation tests
    
    /// Tests navigation in same module without authentication
    func testNavigationInSameModuleWithoutAuthentication() {
        // Get app instance
        let app: XCUIApplication = XCUIApplication()
        
        // Tap first option
        app.staticTexts["testNavigationInSameModuleWithoutAuthentication"].tap()
        
        // Expect corresponding view to appear
        _ = app.staticTexts["This view is from Module 1 and DOES NOT require authentication"].waitForExistence(timeout: 1)
    }
    
    /// Tests navigation in same module with authentication
    func testNavigationInSameModuleWithAuthentication() {
        // Get app instance
        let app: XCUIApplication = XCUIApplication()
        
        // Tap first option
        app.staticTexts["testNavigationInSameModuleWithAuthentication"].tap()
        
        // Expect alert to appear
        let okButton: XCUIElement = app.buttons["OK"]
        _ = okButton.waitForExistence(timeout: 2)
        
        // Tap to dismiss
        okButton.tap()
        
        // Expect corresponding view to appear
        _ = app.staticTexts["This view is from Module 1 and requires authentication"].waitForExistence(timeout: 1)
    }
    
    /// Tests navigation between modules without authentication
    func testNavigationBetweenModulesWithoutAuthentication() {
        // Get app instance
        let app: XCUIApplication = XCUIApplication()
        
        // Tap first option
        app.staticTexts["testNavigationBetweenModulesWithoutAuthentication"].tap()
        
        // Expect corresponding view to appear
        _ = app.staticTexts["This view is from Module 2 and DOES NOT require authentication"].waitForExistence(timeout: 1)
    }
    
    /// Tests navigation between modules with authentication
    func testNavigationBetweenModulesWithAuthentication() {
        // Get app instance
        let app: XCUIApplication = XCUIApplication()
        
        // Tap first option
        app.staticTexts["testNavigationBetweenModulesWithAuthentication"].tap()
        
        // Expect alert to appear
        let okButton: XCUIElement = app.buttons["OK"]
        _ = okButton.waitForExistence(timeout: 2)
        
        // Tap to dismiss
        okButton.tap()
        
        // Expect corresponding view to appear
        _ = app.staticTexts["This view is from Module 2 and requires authentication"].waitForExistence(timeout: 1)
    }
    
    /// Tests external navigation
    func testExternalNavigation() {
        // Declare external navigation link
        let externalNavigationLink: String = "routertestapp:/navigate/view2c/10" // Check SceneDelegate from TestApp for implementation
        
        // Send app to background by pressing home button
        XCUIDevice.shared.press(.home)
        
        // Open Safari
        let safariApp = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
        safariApp.launch()
        
        // Type external navigation link in location bar and navigate
        safariApp.typeText(externalNavigationLink + "\n")
        
        // Tap ok button from system alert, it is always the latest one in hierarchy
        safariApp.buttons["Open"].tap()
        
        // Get app instance
        let app: XCUIApplication = XCUIApplication()
        
        // Ensure expected view appears
        _ = app.staticTexts["Parameter id: 10"].waitForExistence(timeout: 5)
    }
    
    /// Tests interception before navigation
    func testInterceptionBeforeNavigation() {
        // Get app instance
        let app: XCUIApplication = XCUIApplication()
        
        // Tap first option
        app.staticTexts["testInterceptionBeforeNavigation"].tap()
        
        // Expect corresponding view to appear
        _ = app.staticTexts["This is the fifth view of Module 3"].waitForExistence(timeout: 1)
        
        // Tap
        app.staticTexts["testContinueInterceptor"].tap()
        
        // Expect corresponding view to appear
        _ = app.staticTexts["This view is intercepted before navigating"].waitForExistence(timeout: 1)
    }
    
    /// Tests interception after navigation
    func testInterceptionAfterNavigation() {
        // Get app instance
        let app: XCUIApplication = XCUIApplication()
        
        // Tap first option
        app.staticTexts["testInterceptionAfterNavigation"].tap()
        
        // Expect corresponding view to appear
        _ = app.staticTexts["This is the fourth view of Module 3"].waitForExistence(timeout: 1)
        
        // Tap
        app.buttons["testDismissInterceptor"].tap()
        
        // Expect corresponding view to appear
        _ = app.staticTexts["This view is intercepted after navigation"].waitForExistence(timeout: 1)
    }
    
    /// Tests navigation stack handling
    func testNavigationStackHandling() {
        // Get app instance
        let app: XCUIApplication = XCUIApplication()
        
        // Tap first option
        app.staticTexts["testMultipleNavigations1"].tap()
        
        // Expect corresponding view to appear
        _ = app.staticTexts["This is the first view of Module 3."].waitForExistence(timeout: 1)
    
        // Tap first option
        app.staticTexts["testMultipleNavigations2"].tap()

        // Expect corresponding view to appear
        _ = app.staticTexts["This is the second view of Module 3."].waitForExistence(timeout: 1)
        
        // Tap first option
        app.staticTexts["testMultipleNavigations3"].tap()

        // Expect corresponding view to appear
        _ = app.staticTexts["This is the third view of Module 3."].waitForExistence(timeout: 1)
        
        // Tap first option
        app.staticTexts["testMultipleNavigations4"].tap()

        // Expect corresponding view to appear
        _ = app.staticTexts["View 1A"].waitForExistence(timeout: 1)
        _ = app.staticTexts["Navigation stack handling"].waitForExistence(timeout: 1)
    }
}
