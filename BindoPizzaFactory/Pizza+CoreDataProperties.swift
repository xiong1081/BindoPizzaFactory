//
//  Pizza+CoreDataProperties.swift
//  BindoPizzaFactory
//
//  Created by 李招雄 on 2020/3/6.
//  Copyright © 2020 李招雄. All rights reserved.
//
//

import Foundation
import CoreData


extension Pizza {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pizza> {
        return NSFetchRequest<Pizza>(entityName: "Pizza")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var name: String
    @NSManaged public var size: Int64
    @NSManaged public var toppings: Int64
    @NSManaged public var chef: PizzaChef

}
