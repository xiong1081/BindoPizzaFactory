//
//  PizzaChef.swift
//  BindoPizzaFactory
//
//  Created by 李招雄 on 2020/2/28.
//  Copyright © 2020 李招雄. All rights reserved.
//

import Foundation

class PizzaChef {
    let name: String
    let time: Int
    var pizzas: [String] = []
    
    init(name: String, time: Int) {
        self.name = name
        self.time = time
    }
}