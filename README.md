# Preserve and restore scene based app state

This is a sample single view application to preserve and restore state for scene based storyboard application.

## Overview

This sample project demonstrates how to preserve your appʼs state information and restore the app to that previous state on subsequent launches. For example, the user might type a text and leaves or switches apps for something, and the operating system might terminate the app to free up the resources it holds. The user should be able to return to where they left off — and UI state restoration is a core part of making that experience seamless.

This sample app demonstrates the use of state preservation and restoration for scenarios where the system interrupts the app. The sample is to take quick references and preserve them across mutliple launches. The sample supports state preservation for iOS 13 and later, apps save the state for each window scene using [`NSUserActivity`](https://developer.apple.com/documentation/foundation/nsuseractivity) objects.

For scene-based apps, UIKit asks each scene to save its state information using an [`NSUserActivity`](https://developer.apple.com/documentation/foundation/nsuseractivity) object. `NSUserActivity` is a core part of modern state restoration with [`UIScene`](https://developer.apple.com/documentation/uikit/uiscene) and [`UISceneDelegate`](https://developer.apple.com/documentation/uikit/uiscenedelegate). In your own apps, you use the activity object to store information needed to recreate your scene's interface and restore the content of that interface. If your app doesn't support scenes, use the view-controller-based state restoration process to preserve the state of your interface instead. 

For additional information about state restoration, see [Preserving Your App's UI Across Launches](https://developer.apple.com/documentation/uikit/view_controllers/preserving_your_app_s_ui_across_launches).

## Configure the Sample Code Project

In Xcode, select your development team on the iOS target's General tab.

## Enable State Preservation and Restoration

To provide the necessary activity object, the sample implements the [`stateRestorationActivity(for:)`](https://developer.apple.com/documentation/uikit/uiscenedelegate/3238061-staterestorationactivity) method of its scene delegate as shown in the example below. Implementing this method tells the system that the sample supports user-activity-based state restoration. The implementation of this method returns the activity object from the scene's [`userActivity`](https://developer.apple.com/documentation/uikit/uiresponder/1621089-useractivity) property, which the sample populates when the scene becomes inactive.

``` swift
func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
    return scene.userActivity
}
```

## Restore the App State with an Activity Object

Scene-based state restoration is the recommended way to restore the app’s user interface. An [`NSUserActivity`](https://developer.apple.com/documentation/foundation/nsuseractivity) object captures the app's state at the current moment in time. For this sample, the app preserves and restores the notes typed by the user in the ViewController as the user displays or edits it. The sample app saves the notes data in an `NSUserActivity` object when the user closes the app or the app enters the background. When the user launches the app again, the sample's [`scene(_:willConnectTo:options:)`](https://developer.apple.com/documentation/uikit/uiscenedelegate/3197914-scene) method checks for the presence of an activity object. If one is present, the method configures the view controller that the activity object specifies.

``` swift
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity else { return }
        
        if configure(window: window, session: session, with: userActivity) {
            // Remember this activity for later when this app quits or suspends.
            scene.userActivity = userActivity
            scene.title = userActivity.title

        } else {
            Swift.debugPrint("Failed to restore scene from \(userActivity)")
        }
    }
    
    
```

``` swift
    func configure(window: UIWindow?, session: UISceneSession, with activity: NSUserActivity) -> Bool {
        var succeeded = false
        
        // Check the user activity type to know which part of the app to restore.
        if activity.activityType == "ViewController" {


            if let userInfo = activity.userInfo {
               // print("User activity data found\(userInfo["text"] as? String)")
                succeeded = true
            }
        } else {
            // The incoming userActivity is not recognizable here.
        }
        
        return succeeded
    }
```
## Preserving data in View Controller

Here in this listener the data is from the UITextView is pushed to the userActivity for later use

``` swift
   func textViewDidChange(_ textView: UITextView) {

        var currentUserActivity = view.window?.windowScene?.userActivity
        if currentUserActivity == nil {
            currentUserActivity = NSUserActivity(activityType: "ViewController")
        }
        
        // Saving state data.
        currentUserActivity?.addUserInfoEntries(from: ["text": txtViewData.text!])
    
        view.window?.windowScene?.userActivity = currentUserActivity
       }
```


## Restore the App State Using View Controllers

This sample preserves its state by saving the state of its view controller hierarchy. View controllers adopt the [`UIStateRestoring`](https://developer.apple.com/documentation/uikit/uistaterestoring) protocol, which defines methods for saving custom state information to an archive and restoring that information later.

The sample specifies which of its view controllers to save, and assigns a restoration identifier to that view controller. A restoration identifier is a string that UIKit uses to identify a view controller or other user interface element. The identifier for each view controller must be unique. In this sample we have used 'ViewController' as the unique identifier.

``` swift
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let activityUserInfo = view.window?.windowScene?.userActivity?.userInfo {

            if activityUserInfo["text"] != nil {
                
                // Restore the preserved data for the textfield.
                txtViewData.text = activityUserInfo["text"] as? String
  
            }
        }
    }
```



## Test State Restoration on a Device

This is a simple sample to demostrate the state preserving and restoring capabilities.

## License

Copyright © 2022 Lightway

License: [GNU GPLv3](LICENSE)
