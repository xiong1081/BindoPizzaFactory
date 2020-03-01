//
//  Pizza.swift
//  BindoPizzaFactory
//
//  Created by 李招雄 on 2020/2/29.
//  Copyright © 2020 李招雄. All rights reserved.
//

import Foundation

enum PizzaSize: String, CaseIterable {
    case small = "SMALL"
    case medium = "MEDIUM"
    case large = "LARGE"
    
    var weight: Int {
        switch self {
        case .small: return 320
        case .medium: return 530
        case .large: return 860
        }
    }
}

struct PizzaToppings: OptionSet, CaseIterable {
    typealias AllCases = [PizzaToppings]
    static var allCases: [PizzaToppings] {
        [.roastBeef, .bellPappers, .mushrooms, .onions, .tomatoes, .marinara]
    }
    
    let rawValue: Int
    
    static let roastBeef   = PizzaToppings(rawValue: 1 << 0)
    static let bellPappers = PizzaToppings(rawValue: 1 << 1)
    static let mushrooms   = PizzaToppings(rawValue: 1 << 2)
    static let onions      = PizzaToppings(rawValue: 1 << 3)
    static let tomatoes    = PizzaToppings(rawValue: 1 << 4)
    static let marinara    = PizzaToppings(rawValue: 1 << 5)
    
    var description: String {
        switch self {
        case .roastBeef: return "ROAST BEEF"
        case .bellPappers: return "BELL PAPPERS"
        case .mushrooms: return "MUSHROOMS"
        case .onions: return "ONIONS"
        case .tomatoes: return "TOMATOES"
        case .marinara: return "MARINARA"
        default: return ""
        }
    }
}

class Pizza {
    let name: String
    var size: PizzaSize = .medium
    var toppings: PizzaToppings? = nil
    var completed = false
    
    init(name: String) {
        self.name = name
    }
}
