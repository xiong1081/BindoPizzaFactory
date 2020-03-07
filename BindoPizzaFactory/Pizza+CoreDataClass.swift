//
//  Pizza+CoreDataClass.swift
//  BindoPizzaFactory
//
//  Created by 李招雄 on 2020/3/6.
//  Copyright © 2020 李招雄. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Pizza)
public class Pizza: NSManagedObject {
    func update(name: String,
         size: Int64 = PizzaSize.medium.rawValue,
         toppings: Int64 = 0,
         completed: Bool = false) {
        self.name = name
        self.size = size
        self.toppings = toppings
        self.completed = completed
    }
}


enum PizzaSize: Int64, CaseIterable {
    case small = 320
    case medium = 530
    case large = 860
    
    var description: String {
        switch self {
        case .small: return "SMALL"
        case .medium: return "MEDIUM"
        case .large: return "LARGE"
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
