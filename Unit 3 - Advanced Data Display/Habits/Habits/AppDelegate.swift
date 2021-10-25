//
//  AppDelegate.swift
//  Habits
//
//  Created by wickedRun on 2021/10/17.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // image를 받게 되어 기본값은 적으므로 또 갖고 오는 것은 비효율이니까 한번 가지고 온것을 저장해둔다.
        let temporaryDirectory = NSTemporaryDirectory()
        // AppDelegate 내에서 새 URLCache를 만들어 네트워크 요청이 발생하기 전에 캐시가 생성되도록합니다.
        // 앱의 임시디렉터리에 저장되는 URLCache를 만들고,
        let urlCache = URLCache(memoryCapacity: 25_000_000, diskCapacity: 50_000_000, diskPath: temporaryDirectory)
        // URLSession이 사용할 shared 캐시에 할당합니다.
        URLCache.shared = urlCache
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

