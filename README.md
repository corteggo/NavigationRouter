# NavigationRouter

NavigationRouter is a router implementation designed for complex modular apps, written in Swift.

<p>
    <img src='https://github.com/corteggo/NavigationRouter/workflows/build/badge.svg'>
    <img src='https://github.com/corteggo/NavigationRouter/workflows/test/badge.svg'>
        <a href="https://codecov.io/gh/corteggo/NavigationRouter"><img src="https://codecov.io/gh/corteggo/NavigationRouter/branch/main/graph/badge.svg" /></a>
    <img src='https://img.shields.io/github/v/tag/corteggo/NavigationRouter?color=lightGray&label=version'>
    <img src='https://img.shields.io/github/license/corteggo/NavigationRouter?color=lightGray'>
    <a href='https://twitter.com/corteggo'><img src='https://img.shields.io/badge/twitter-@corteggo-lightGray.svg?style=flat&label=contact'></a>
</p>

## Features :star2:

- [x] Decoupled **routing registration**.
- [x] **Decoupled navigation** between views and modules.
- [x] Custom navigations with **parameters**.
- [x] **Navigation interceptions** to make things easier (onboardings, tutorials...).
- [x] Lightweight codebase.
- [x] Works with **iOS**, **iPadOS** and **macOS** Catalyst.
- [x] Works with both **UIKit** and **SwiftUI**.
- [x] Supports **external navigation** handling.
- [x] Supports **multiple UIScene** instances.
- [x] Supports any kind of **authentication** for routing permissions. Including OAuth authentication callbacks.

Please note SwiftUI support requires iOS 13.0 or newer and macOS 10.15 or newer.

## Supported platforms :iphone:

* iOS 8.0+.
* macOS 10.15+.
* Xcode 11.0+.
* Swift 5.0+.

watchOS and tvOS support will eventually be added in future releases.

## How does it work :question:

Writing simple apps is easy but writing large ones can be very complex. At that point modular architectures usually come to the rescue, but it's hard to navigate between views and modules without coupling them, ending in a very complex dependency graph that's hard to maintain and developers leave your company because the project becomes no longer attractive.

This library tries to fix that problem, so your developers are still happy after many years of app development. It has been designed to navigate between different views and modules without actually knowing the destination object, making things easier.

I recommend you to read my article about [Building complex modular architectures with SwiftUI, Combine and Swift Package Manager (SPM)](https://medium.com/cristian-ortega/modular-architectures-swiftui-combine-swift-package-manager-80820b4ff463) to understand how this router works internally.

## Installation :gear:

### Swift Package Manager

[Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and it is integrated in `Xcode`. Once you have your project ready, adding `NavigationRouter` as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift` manifest file or to the "Swift packages" tab in `Xcode`.

```swift
dependencies: [
    .package(url: "https://github.com/corteggo/NavigationRouter.git", .branch("main"))
]
```

You can choose between always using the latest version (`main` branch) or using a specific version.

### CocoaPods

[CocoaPods](https://cocoapods.org) is a centralized dependency manager for iOS projects. For usage and installation instructions, please visit their website. To integrate `NavigationRouter` into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'NavigationRouter', :git => 'https://github.com/corteggo/NavigationRouter.git', :branch => 'main'
```

I've decided not to make this project available in central repository. Please consider dropping CocoaPods usage as it will no longer be supported by this library in the future, given that Swift Package Manager now supports binaries and resources as of Xcode 12. There's no need to use CocoaPods anymore.

## How to use it :grey_question:

Check out [DOCUMENTATION.md](https://github.com/corteggo/NavigationRouter/blob/main/DOCUMENTATION.md) for details.

### Sample project

Please download the project and run "NavigationRouterTestApp" for a working example. It supports iOS, iPadOS and macOS Catalyst and shows all available scenarios described here.

## Known issues :bangbang:

### Navigating between SwiftUI views
Please note when using two SwiftUI views hosted with UIHostingController a weird animation happens when you're navigating between views using different UINavigationBar display modes. As a workaround, when using SwiftUI for your app, always choose between "large" or "inline" display modes but do not mix them in the same navigation route. You can also leave it at `.automatic` to avoid this problem. This has already been reported to Apple via Feedback Assistant as FB7648851.

## Miscelanea :busstop:

* Changelog: check out [CHANGELOG.md](https://github.com/corteggo/NavigationRouter/blob/main/CHANGELOG.md) for details.
* Credits: NavigationRouter is owned and maintained by [corteggo](https://www.linkedin.com/in/corteggo/).
* License: NavigationRouter is released under the MIT license. See [LICENSE](https://github.com/corteggo/NavigationRouter/blob/master/LICENSE) for details.
* Want to contribute? Suggest your idea as a [feature request](https://github.com/corteggo/NavigationRouter/issues/new?assignees=&labels=&template=&title=) for this project or create a [bug report](https://github.com/corteggo/NavigationRouter/issues/new?assignees=&labels=&template=.md&title=).
