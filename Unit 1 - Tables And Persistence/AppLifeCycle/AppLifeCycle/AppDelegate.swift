//
//  AppDelegate.swift
//  AppLifeCycle
//
//  Created by wickedRun on 2021/08/08.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // 앱이 시작됬을 때 호출되는 메서드
        print("Application did finish launching.")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        // 새로운 신 세션이 생성되면 호출되는 메소드
        // 밑에 "Default Contfiguration" 같은건 여기서 다루지 않는다.
        print("Scene session is created")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        // 사용자가 아이패드에서 앱의 인스턴스를 버릴때 신에 대한 정보와 함께 호출된다.
        print("Scene session is discarded")
    }


}

