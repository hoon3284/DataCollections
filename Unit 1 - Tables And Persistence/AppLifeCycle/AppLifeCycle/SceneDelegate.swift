//
//  SceneDelegate.swift
//  AppLifeCycle
//
//  Created by wickedRun on 2021/08/08.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configura'tionForConnectingSceneSession` instead).
        
        // 이 메서드는 로컬저장공간이나 네트워크 연결로부터 데이타를 불러오는 것 같은 추가적인 scene을 준비하는 어떤 필수적인 단계를 수행할 기회를 제공한다.
        print("Scene will connect to session.")
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        
        // 이 메서드는 scene이 앱에서 제거되었을 때 호출되며, 어떤 리소스를 clean up하고 해제하는 또는 장면에 필요한 파일을 저장하는 최적의 장소이다.
        print("Scene did Disconnect")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        // 이 메서드는 scene이 inactive에서 active state로 옮겨졌을 때 호출된다.
        print("Scene did become active")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        
        // 이 메서드는 scene이 active에서 inactive로 움직이려고 할 때 호출된다.
        print("Scene will resign active.")
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        // 이 메서드는 scene이 백그라운드에서 포그라운드로 이동할때 호출된다.
        print("Scene will enter foreground.")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // 이 메서드는 scene이 포그라운드에서 백그라운드로 이동할 때 호출된다.
        print("Scene did enter background")
    }


}

