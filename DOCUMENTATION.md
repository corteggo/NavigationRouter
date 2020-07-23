# NavigationRouter

## Documentation

Once you have it installed in your project, you must follow these steps in order to make it work with your own app.

1. [Creating the router](#creating-the-router)
2. [Creating routable modules](#creating-routable-modules)
3. [Creating views and view models](#creating-views-and-view-models)
4. [Registering navigation routes](#registering-navigation-routes)
5. [Navigating between routes](#navigating-between-routes)
6. [Intercepting navigation](#intercepting-navigation)
7. [Adding authentication handling](#adding-authentication-handling)
8. [Supporting multiple scenes](#supporting-multiple-scenes)

---

### <a name="creating-the-router"></a>1. Creating the router

There's a shared instance named `NavigationRouter` that you can use if your app supports only one scene, but you can also create new instances with `.init(scene:)` method. 

If you don't want to use dependency injection in your code (which is a very bad idea), you can manually use and create instances to navigate between views and modules:

```swift
// Shared navigation router
NavigationRouter.main.navigate(toPath: "/your/path")

// Custom instance
let router: NavigationRouter = NavigationRouter(scene: <UIScene instance here>)
router.navigate(toPath: "/your/path")
```

If you're already using any dependency injection management system, you can use it to handle `NavigationRouter` instances as well. I recommend using [Resolver](https://github.com/hmlongco/Resolver) because it's very simple:

```swift
import NavigationRouter
import Resolver

// Somewhere in your code
Resolver
    .register {
        NavigationRouter.main
    }
```

Then in your code, you can use instance like this:

```swift
private var router: NavigationRouter = Resolver.resolve()

// Somewhere in your code:
router.navigate(toPath: "/...")
```

If you're targeting iOS 13.0 or newer, you can also use property wrappers for better readability:

```swift
@LazyInjected private var router: NavigationRouter

// Somewhere in your code:
router.navigate(toPath: "/...")
```

---

### <a name="creating-routable-modules"></a>2. Creating routable modules

Once your router instance is ready, you must create a class that conforms to protocol `RoutableModule` in every module you have. This will describe the routes and interceptors as shown below:

```swift
import NavigationRouter

/// Feature A module definition
public final class FeatureAModule: RoutableModule {
    // MARK: - Initializers
    
    /// Initializes a new instance
    public init() {
        // Initialize instance here as needed
    }
    
    // MARK: - Routing
    
    /// Registers navigation routes
    public func registerRoutes() {
        // Register routes here as needed
    }
    
    /// Registers navigation interceptors
    public func registerInterceptors() {
        // Register interceptors here as needed
    }
}
```

In order for routable modules to be found at runtime, you must add the following line to your AppDelegate initialization method before anything else:

```swift
RoutableModulesFactory.loadRoutableModules()
```

This method is using Runtime APIs underneath so you don't need to do any additional step. 

---

### <a name="creating-views-and-models"></a>3. Creating views and view models

You can create a sample view and view model as shown below:

#### UIKit

```swift
import UIKit
import NavigationRouter

/// Routable view model
struct ViewModel1A: RoutableViewModel {
    // MARK: - Routing
    
    /// Required navigation parameters (if any)
    static var requiredParameters: [String]?
    
    /// Navigation interception execution flow (if any)
    var navigationInterceptionExecutionFlow: NavigationInterceptionFlow?
    
    /// Initializes a new instance
    /// - Parameter parameters: Navigation parameters
    init(parameters: [String : String]?) {
        // Do something with parameters (e.g. instantiating a model)
    }
    
    /// View body
    var routedViewController: UIViewController {
        // Instantiate and return your view controller in any way
        let viewController: ViewController1 = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "viewController1") as! ViewController1
        viewController.viewModel = self
        return viewController
    }
}

/// ViewController 1A
class ViewController1A: UIViewController, RoutableViewController {
    // MARK: - Fields
    
    /// View model instance
    var viewModel: ViewModel1A!
    
    // MARK: - Initializers
    
    /// Initializes a new instance with given data
    /// - Parameters:
    ///   - nibNameOrNil: Nib name or nil
    ///   - nibBundleOrNil: Nib bundle or nil
    ///   - viewModel: View model instance
    required init(nibName nibNameOrNil: String?,
                  bundle nibBundleOrNil: Bundle?,
                  viewModel: ViewModel1A) {
        self.viewModel = viewModel
        
        super.init(nibName: nibNameOrNil,
               bundle: nibBundleOrNil)
    }
    
    /// Initializes a new instance with given data
    /// - Parameters:
    ///   - coder: Coder instance
    ///   - viewModel: View model instance
    required init?(coder: NSCoder,
                   viewModel: ViewModel1A) {
        self.viewModel = viewModel
        
        super.init(coder: coder)
    }
    
    /// Initializes a new instance with given coder
    /// - Parameter coder: Coder instance
    required init?(coder: NSCoder) {
        super.init(coder:coder)
    }
}
```

You can add observable properties to your `RoutableViewModel` in order to be able to observe them from your `RoutableViewController` using [Combine](https://developer.apple.com/documentation/combine) or [RxSwift](https://github.com/ReactiveX/RxSwift) as you probably do right now, so it is very easy to add this library to your project with your existing codebase.

#### SwiftUI

Please note `SwiftUI.NavigationView` is not mature enough to perform complex navigations (e.g. replacing the stack at some random point and so on). For this reason, we use `UIHostingController` to wrap all `SwiftUI.View` instances into a `UIViewController` so we can still using `UINavigationController`:

```swift
import SwiftUI
import NavigationRouter

/// Routable view model
struct ViewModel1A: RoutableViewModel {
    // MARK: - Routing
    
    /// Required navigation parameters (if any)
    static var requiredParameters: [String]?
    
    /// Navigation interception execution flow (if any)
    var navigationInterceptionExecutionFlow: NavigationInterceptionFlow?
    
    /// Initializes a new instance
    /// - Parameter parameters: Navigation parameters
    init(parameters: [String : String]?) {
        // Do something with parameters (e.g. instantiating a model)
    }
    
    /// View body
    var routedView: AnyView {
        // Return your view and wrap it using UIHostingController
        return View1A(viewModel: self)
            .eraseToAnyView()
    }
}

/// View 1A
struct View1A: RoutableView {
    // MARK: - Fields
    
    /// View model instance
    var viewModel: ViewModel1A
    
    // MARK: - Initializers
    
    /// Initializes a new instance with given view model
    /// - Parameter viewModel: View model instance
    init(viewModel: ViewModel1A) {
        self.viewModel = viewModel
    }

    // MARK: - View body
    
    /// Body builder
    var body: some View {
        // Your view body here
    }
}
```

Please note you can also make your `RoutableViewModel` instance conform to `ObservedObject` protocol and change it from struct to class in order to be able to add `@ObservedObject` to your `RoutableViewModel` in your `RoutableView`:

```swift
/// Routable view model
class ViewModel1A: RoutableViewModel, ObservedObject {
    // ...
}

/// Routable view
struct View1A: RoutableView {
    // MARK: - Fields
    
    /// View model instance
    @ObservedObject var viewModel: ViewModel1A
    
    // ...
}
```

This way, your `SwiftUI.View` will react to changes of your `RoutableViewModel`. Please note `RoutableViewModel` is instantiated by `NavigationRouter` and passed to your view via an initializer, so you don't have control over created instances. This is intended to avoid mistakes.

You can also use @State, @StateObject, @Environment and any other SwiftUI modifier. Also, even though `NavigationRouter` requires an instance of `UIViewController`, `UIHostingController` provides you the functionality for many modifiers to work, such as `.navigationBarTitle(_, displayMode:)`. In fact, the only UIKit you'd need to use is the `.asUIViewController()` invocation.

---

### <a name="registering-navigation-routes"></a>4. Registering navigation routes

Routes are always registered within `registerRoutes` method of `RoutableModule` and it must be done synchronously.

```swift
/// Registers navigation routers
public func registerRoutes() {
    // Define routes
    let view1ARoute: NavigationRoute = NavigationRoute(
        path: "/view1A",
        type: ViewModel1A.self,
        requiresAuthentication: false)
    let view1BRoute: NavigationRoute = NavigationRoute(
        path: "/view1B",
        type: ViewModel1B.self,
        requiresAuthentication: false,
        allowedExternally: true)
    let view1CRoute: NavigationRoute = NavigationRoute(
        path: "/view1C",
        type: ViewModel1C.self,
        requiresAuthentication: true)
    
    // Register routes
    NavigationRouter.bind(routes: [
        view1ARoute,
        view1BRoute,
        view1CRoute
    ])
}
```

Please note your view model must conform to `RoutableViewModel` protocol.

---

### <a name="navigating-between-routes"></a>5. Navigating between routes

Once you have registered your routes, you can navigate to them like this:

```
router.navigate(toPath: "/your/registered/path")
```

You can pass the following arguments:
* toPath: `String`. Destination path to navigate to. Must be an already registered string.
* replace: `Bool`. Whether to replace the navigation stack or not. Defaults to `false`.
* externally: `Bool`. Whether the navigation is coming from an external source or not. Defaults to `false`.
* embedInNavigationView: `Bool`. Whether the destination must be embedded in an UINavigationController instance or not, only if the root view controller for the UIScene instance associated to the NavigationRouter is not an UINavigationController instance already. Defaults to `true`.
* modal: `Bool`. Whether the destination must be presented instead of pushed onto UINavigationController. Defaults to `false`.
* shouldPreventDismissal: `Bool`. Only used with modal=true, defines whether the modal can be dismissed by user by swiping it down or not. Defaults to `false`. It is supported on iOS 13.0 or newer.
* interceptionExecutionFlow: `Optional<NavigationInterceptionFlow>`. It contains a block to handle navigation interceptions, it is explained below in the following sections.
* animation: `Optional<NavigationTransition>`. A custom animation to use when replace=true, since the destination will become the root view controller of the UINavigationController instance, removing the previous navigation stack. Possible values are `.left`, `.right`, `.top` and `.bottom`, although you can create your own with `.function`.

If you're using SwiftUI, you can also use `RoutedLink` view to use a declarative-style navigation:

 ```swift
import NavigationRouter
import SwiftUI

struct YourView: View {
    var body: some View {
        VStack {
            // whatever
            
            RoutedLink(toPath: "/your/destination/path") {
                // Add any SwiftUI.View here, like Text or Image.
                // This automatically adds an .onTapGesture to handle navigation.
            }
            
            // whatever
        }   
    }
}
```

Other parameters are available as well as in `NavigationRouter.navigate` method.

---

### <a name="intercepting-navigation"></a>6. Intercepting navigation

There're situations where you need to intercept navigation to show something different (e.g. onboardings or tutorials, among others). You can intercept a navigation as shown below:

```swift
/// Registers interceptors
public func registerInterceptors() {
    // Intercept home view
    NavigationRouter.interceptNavigation(
        toPath: "/home",
        when: .after, // Intercept after navigating
        withPriority: .low,
        requiringAuthentication: false) { router, executionFlow in
        // Save execution flow
        let interceptionFlow: NavigationInterceptionFlow = 
            NavigationInterceptionFlow(completion: executionFlow)
            
        // Navigate to tutorial view
        router.navigate(toPath: "/onboarding",
                        modal: true,
                        interceptionExecutionFlow: interceptionFlow)
    }
    
    // Intercept accounts view
    NavigationRouter.interceptNavigation(
        toPath: "/accounts",
        when: .before, // Intercept before navigating
        withPriority: .low,
        requiringAuthentication: false) { router, executionFlow in
        // Save execution flow
        let interceptionFlow: NavigationInterceptionFlow = NavigationInterceptionFlow(completion: executionFlow)
        
        // Navigate to tutorial view for accounts
        router.navigate(
            toPath: "/accounts/tutorial",
            interceptionExecutionFlow: interceptionFlow)
    }
}
```

You have additional options for intercepting routes:

* when: `NavigationInterceptorPoint`. The point where you want to intercept navigation at. It can be either `.before` or `after`. Defaults to `.before`.
* withPriority: `NavigationInterceptionPriority`. The priority you want to intercept navigation with, in case there're multiple interceptors for the same route. It can be `.low`, `.medium`, `.high` or `.mandatory`. Defaults to `.low`.
* requiringAuthentication: `Bool`. Whether the interceptors requires user to be authenticated or not. Interceptors that do not require authentication will be shown before actually promp the user for authentication and the other ones will appear later. Defaults to `false`.

---

### <a name="adding-authentication-handling"></a>7. Adding authentication handling

You can use your own authentication handling to perform navigation. This library exposes `NavigationRouterAuthenticationHandler`  protocol so that you can provide your own implementation. It exposes the following methods:

```swift
/// Navigation router authentication handler
public protocol NavigationRouterAuthenticationHandler {
    // MARK: - Authentication
    
    /// Gets whether user is authenticated or not
    var isAuthenticated: Bool { get }
    
    /// Logins user
    /// - Parameter completion: Completion handler
    func login(completion: (() -> Void)?)
    
    /// Logouts user
    /// - Parameter completion: Completion handler
    func logout(completion: (() -> Void)?)
}
```

It is your own responsibility to show login view accordingly or handle session expiration. Optionally, you can also implement the following methods (this will help you deal with OAuth authorization callbacks or similar scenarios):

```swift
/// Gets whether authentication handler can handle given callback URL or not
/// - Parameter url: URL to be handled
func canHandleCallbackUrl(_ url: URL) -> Bool

/// Handles given callback URL
/// - Parameter url: URL to be handled
func handleCallbackUrl(_ url: URL)
```

When you're registering routes, you can specify whether a specific route requires user to be authenticated within your app or not. The same works for navigation interceptors as explained above. 

---

### <a name="supporting-multiple-scenes"></a>8. Supporting multiple scenes

If your app supports multiple UIScene instances on iPadOS or macOS Catalyst, you can also create a different `NavigationRouter` instance for each of them. You can use `.init(scene:)` method in order to provide the UIScene instance the router will work with:

```swift
// First router
let firstRouter: NavigationRouter = NavigationRouter(scene: firstScene)
let secondRouter: NavigationRouter = NavigationRouter(scene: secondScene)
// ...

// Navigations
firstRouter.navigate(toPath: "/home")
secondRouter.navigate(toPath: "/accounts")
```

All navigations wil be performed in the given UIScene. Please note this also works if your app supports CarPlay, since you have a specific UIScene instance with .carPlay value in UITraitCollection. Hence, you can use this project everywhere except watchOS and tvOS at this moment.

You can also create multiple instances using your desired dependency injection framework and assign them a name, so you can use them accordingly.
