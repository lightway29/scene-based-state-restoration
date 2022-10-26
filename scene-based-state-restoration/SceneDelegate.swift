//
//  SceneDelegate.swift
//  scene-based-state-restoration
//
//  Created by Kamal Bogahagedara on 2022-10-26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


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
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {

        return scene.userActivity
    }
    
    
    func configure(window: UIWindow?, session: UISceneSession, with activity: NSUserActivity) -> Bool {
        var succeeded = false
        
        // Check the user activity type to know which part of the app to restore.
        if activity.activityType == "ViewController" {


            if let userInfo = activity.userInfo {
//                print("User activity data found\(userInfo["text"] as? String)")
                succeeded = true
            }
        } else {
            // The incoming userActivity is not recognizable here.
        }
        
        return succeeded
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

