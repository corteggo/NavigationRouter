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

/// Routable modules factory
public final class RoutableModulesFactory {
    // MARK: - Fields
    
    /// Whether routable modules have already been registered or not
    private static var modulesAlreadyRegistered: Bool = false
    
    // MARK: - Public methods

    /// Loads all modules conforming to RoutableModule protocol
    public static func loadRoutableModules() {
        // Make sure we always perform this on main thread, safely
        DispatchQueue.mainSyncSafe {
            // Ensure we register this just once to avoid duplicated stuff in the router
            guard !Self.modulesAlreadyRegistered else {
                return
            }
            
            // Set modules as registered
            Self.modulesAlreadyRegistered = true
            
            // Find all classes
            let featureClasses: [RoutableModule.Type] =
                Self.getClassesConformingProtocol(RoutableModule.self) as?
                    [RoutableModule.Type] ?? []
            
            // Register each feature
            for feature in featureClasses {
                let featureInstance: RoutableModule = feature.init()
                
                // Setup feature
                featureInstance.setup?()
                
                // Register routes
                featureInstance.registerRoutes?()
                
                // Register interceptors
                featureInstance.registerInterceptors?()
            }
        }
    }
    
    // MARK: - Private methods
    
    /// Gets classes conforming to given Protocol
    /// - Parameter p: Protocol description
    private static func getClassesConformingProtocol(_ protocolToConform: Protocol) -> [AnyClass] {
        let expectedClassCount = objc_getClassList(nil, 0)
        let allClasses = UnsafeMutablePointer<AnyClass>.allocate(capacity: Int(expectedClassCount))
        let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(allClasses)
        let actualClassCount: Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)

        // swiftlint:disable identifier_name
        var classes = [AnyClass]()
        for i in 0 ..< actualClassCount {
            let currentClass: AnyClass = allClasses[Int(i)]
            if class_conformsToProtocol(currentClass, protocolToConform) {
                classes.append(currentClass)
            }
        }
        // swiftlint:enable identifier_name

        return classes
    }
}
