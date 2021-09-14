//
//  Restoration.swift
//  OrderApp
//
//  Created by wickedRun on 2021/09/13.
//

import Foundation

extension NSUserActivity {
    
    var controllerIdentifier: StateRestorationController.Identifier? {
        get {
            if let controllerIdentifierString = userInfo?["controllerIdentifier"] as? String {
                return StateRestorationController.Identifier(rawValue: controllerIdentifierString)
            } else {
                return nil
            }
        }
        set {
            userInfo?["controllerIdentifier"] = newValue?.rawValue
        }
    }
    
    var menuCategory: String? {
        get {
            return userInfo?["menuCategory"] as? String
        }
        set {
            userInfo?["menuCategory"] = newValue
        }
    }
    
    var menuItem: MenuItem? {
        get {
            guard let jsonData = userInfo?["menuItem"] as? Data else {
                return nil
            }
            return try? JSONDecoder().decode(MenuItem.self, from: jsonData)
        }
        set {
            if let newValue = newValue, let jsonData = try? JSONEncoder().encode(newValue) {
                addUserInfoEntries(from: ["menuItem": jsonData])
            } else {
                userInfo?["menuItem"] = nil
            }
        }
    }
    
    var order: Order? {
        get {
            guard let jsonData = userInfo?["order"] as? Data else {
                return nil
            }
            return try? JSONDecoder().decode(Order.self, from: jsonData)
        }
        set {
            if let newValue = newValue, let jsonData = try? JSONEncoder().encode(newValue) {
                addUserInfoEntries(from: ["order": jsonData])
            } else {
                userInfo?["order"] = nil
            }
        }
    }
}

enum StateRestorationController {
    
    init?(userActivity: NSUserActivity) {
        guard let identifier = userActivity.controllerIdentifier else {
            return nil
        }
        switch identifier {
        case .categories:
            self = .categories
        case .menu:
            if let category = userActivity.menuCategory {
                self = .menu(category: category)
            } else {
                return nil
            }
        case .menuItemDetail:
            if let menuItem = userActivity.menuItem {
                self = .menuItemDetail(menuItem)
            } else {
                return nil
            }
        case .order:
            self = .order
        }
    }
    
    // 이 enum은 Storyboard에서 Storyboard ID를 case의 rawValue로 설정해뒀기에 이 enum을 통해 어떤 ViewController인지 표현하기위해 정의.
    enum Identifier: String {
        case categories, menu, menuItemDetail, order
    }
    
    case categories
    case menu(category: String)
    case menuItemDetail(MenuItem)
    case order
    
    // 이렇게 identifier를 변수로 만든 이유는 현재 내 상태를 표현할 수 있는 변수로 저장하기 위해서 인거 같다.
    var identifier: Identifier {
        switch self {
        case .categories: return Identifier.categories
        case .menu: return Identifier.menu
        case .menuItemDetail: return Identifier.menuItemDetail
        case .order: return Identifier.order
        }
    }
}
