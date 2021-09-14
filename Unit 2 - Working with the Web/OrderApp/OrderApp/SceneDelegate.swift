//
//  SceneDelegate.swift
//  OrderApp
//
//  Created by wickedRun on 2021/09/07.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var orderTabBarItem: UITabBarItem!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        // 여기서도 옵저버를 달고 MenuController.orderUpdateNotification이름의 알림이 오면 updateOrderBadge 함수 호출.
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrderBadge), name: MenuController.orderUpdatedNotification, object: nil)
        // orderTabBarItem 값 가져오는 명령/ window의 rootViewController를 UITabBarController로 캐스팅후에 viewcontroller변수에서 2번째의 tabbarItem.
        orderTabBarItem = (window?.rootViewController as? UITabBarController)?.viewControllers?[1].tabBarItem
        
        if let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity {
            configureScene(for: userActivity)
        }
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
    
    @objc func updateOrderBadge() {
        // 항목이 있다가 0이 되면 뱃지에 0이 있기 때문에 0이 될땐 뱃지를 없애는 처리.
        // if-else로 작성하지 않은 이유는.
        // switch의 case let 구문을 이용하면 훨씬 깨끗한 코드를 작성할 수 있기 때문이다.
        switch MenuController.shared.order.menuItems.count {
        case 0:
            orderTabBarItem.badgeValue = nil
        case let count:
            orderTabBarItem.badgeValue = String(count)
        }
    }
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return MenuController.shared.userActivity
    }
    
    func configureScene(for userActivity: NSUserActivity) {
        if let restoredOrder = userActivity.order {
            MenuController.shared.order = restoredOrder
        }
        
        guard let restorationController = StateRestorationController(userActivity: userActivity),
              // userActivity를 이용한 initializer로 StateRestorationController 생성.
              let tabBarController = window?.rootViewController as? UITabBarController,
              // window의 rootViewController를 tabbarController로 얻어온다.
              tabBarController.viewControllers?.count == 2,
              // 받아온 tabbarcontroller가 맞는지 확인한다.
              let categoryTableViewController = (tabBarController.viewControllers?[0] as? UINavigationController)?.topViewController as? CategoryTableViewController
              // categoryTableViewController와 orderTableViewController는 자동으로 생성되기 때문에 TabBarController의 컨트롤러의 배열에서 0번째 항목을 NavigationController로 캐스팅한 후에 tobViewController 변수의 값을 CategoryTableViewController로 캐스팅해서 얻어온다.
        else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)    // name은 storyboard 파일 이름. 틀리면 충돌난다.
        
        switch restorationController {  // 아까 userActivity를 통해 생성했던 restorationController의 case에 따라 처리해준다.
        case .categories:
            // TabBarController를 만들때 CategoryTableViewController는 자동 생성되고 기본 인덱스가 0이므로 따로 해줄 처리가 없으므로 break로 처리해준다.
            break
        case .order:
            // TabbarController를 만들때 orderTableViewController도 자동 생성되므로 선택된 인덱스만 바꿔준다.
            tabBarController.selectedIndex = 1
        case .menu(let category):
            // storyboard의 instantiateViewController 메소드를 호출하여 menuTableViewController를 생성한다.
            // 이 메소드는 @IBSegueAction 구현하는 것과 비슷하다.
            let menuTableViewController = storyboard.instantiateViewController(identifier: restorationController.identifier.rawValue, creator: { (coder) in
                return MenuTableViewController(coder: coder, category: category)
            })
            // 위에서 생성한 menuTableViewController를 categoryTableViewController의 navigationController에 푸시한다.
            categoryTableViewController.navigationController?.pushViewController(menuTableViewController, animated: true)
        case .menuItemDetail(let menuItem):
            let menuTableViewController = storyboard.instantiateViewController(identifier: StateRestorationController.Identifier.menu.rawValue, creator: { (coder) in
                return MenuTableViewController(coder: coder, category: menuItem.category)
            })
            
            let menuItemDetailViewController = storyboard.instantiateViewController(identifier: restorationController.identifier.rawValue, creator: { (coder) in
                return MenuItemDetailViewController(coder: coder, menuItem: menuItem)
            })
            // 두개나 넣기 때문에 animated는 false해주는 것 같다.
            categoryTableViewController.navigationController?.pushViewController(menuTableViewController, animated: false)
            categoryTableViewController.navigationController?.pushViewController(menuItemDetailViewController, animated: false)
        }
    }
}

