//
//  PizzaChef+CoreDataProperties.swift
//  BindoPizzaFactory
//
//  Created by 李招雄 on 2020/3/6.
//  Copyright © 2020 李招雄. All rights reserved.
//
//

import Foundation
import CoreData


extension PizzaChef {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PizzaChef> {
        return NSFetchRequest<PizzaChef>(entityName: "PizzaChef")
    }

    @NSManaged public var name: String
    @NSManaged public var time: Int64
    @NSManaged public var pizzas: NSSet

}

// MARK: Generated accessors for pizzas
extension PizzaChef {

    @objc(addPizzasObject:)
    @NSManaged public func addToPizzas(_ value: Pizza)

    @objc(removePizzasObject:)
    @NSManaged public func removeFromPizzas(_ value: Pizza)

    @objc(addPizzas:)
    @NSManaged public func addToPizzas(_ values: NSSet)

    @objc(removePizzas:)
    @NSManaged public func removeFromPizzas(_ values: NSSet)

}
