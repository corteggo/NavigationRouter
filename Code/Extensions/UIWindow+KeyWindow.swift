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
import UIKit

// MARK: - Key window access (multi OS versions support)
public extension UIWindow {
    /// Key window
    static var keyWindow: UIWindow? {
        if #available(iOS 13.0, macOS 10.15, *) {
            return UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive }).map({$0 as? UIWindowScene})
                .compactMap({ $0 }).first?.windows.filter({
#if targetEnvironment(macCatalyst)
                    return true
#else
                    return $0.isKeyWindow
#endif
                }).first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    /// Gets window for given UIScene instance
    /// - Parameter scene: UIScene instance to return window for
    /// - Returns: UIWindow corresponding to given UIScene
    @available(iOS 13.0, macOS 10.15, *)
    static func keyWindow(forScene scene: UIScene) -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter({ $0 == scene }).map({$0 as? UIWindowScene})
            .compactMap({$0}).first?.windows.filter({
#if targetEnvironment(macCatalyst)
                return true
#else
                return $0.isKeyWindow
#endif
            }).first
    }
}
