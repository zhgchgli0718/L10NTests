# Using CocoaPods-Keys in Swift projects

Once you've followed the setup instructions described in the [Usage](README.md#usage)
section of the README, you are ready to use `Keys` from Swift.

## Importing the framework

Use Swift's `import` statement. The name of the generated
module is `Keys`.

```swift
import Keys
```

## Usage

```swift
let keys = MyApplicationKeys()
ARAnalytics.setupWithAnalytics(keys.analyticsToken)
```

### Troubleshooting

You can get into a situation where you have an existing integrated project but when you add a new key it isn't recognized in the file(s) you `import Keys` in, although your project is configured properly (you can check by verifying it's shown with a `pod keys` and/or manually viewing the generated `*.h/*.m` files). 

The fix: clear out your Xcode's Derived Data finder folder and rebuilding should generate a proper swift class in the Keys module.
