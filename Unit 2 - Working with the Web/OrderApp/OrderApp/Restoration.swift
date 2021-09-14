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
    
    enum Identifier: String {
        case categories, menu, menuItemDetail, order
    }
    
    case categories
    case menu(category: String)
    case menuItemDetail(MenuItem)
    case order
    
    var identifier: Identifier {
        switch self {
        case .categories: return Identifier.categories
        case .menu: return Identifier.menu
        case .menuItemDetail: return Identifier.menuItemDetail
        case .order: return Identifier.order
        }
    }
}
