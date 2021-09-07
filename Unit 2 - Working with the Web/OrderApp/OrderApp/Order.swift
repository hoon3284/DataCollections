//
//  Order.swift
//  OrderApp
//
//  Created by wickedRun on 2021/09/07.
//

import Foundation

struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
