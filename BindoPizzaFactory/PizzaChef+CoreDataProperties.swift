//
//  PizzaChef+CoreDataProperties.swift
//  BindoPizzaFactory
//
//  Created by 李招雄 on 2020/3/7.
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
    @NSManaged public var pizzas: NSOrderedSet

}

// MARK: Generated accessors for pizzas
extension PizzaChef {

    @objc(insertObject:inPizzasAtIndex:)
    @NSManaged public func insertIntoPizzas(_ value: Pizza, at idx: Int)

    @objc(removeObjectFromPizzasAtIndex:)
    @NSManaged public func removeFromPizzas(at idx: Int)

    @objc(insertPizzas:atIndexes:)
    @NSManaged public func insertIntoPizzas(_ values: [Pizza], at indexes: NSIndexSet)

    @objc(removePizzasAtIndexes:)
    @NSManaged public func removeFromPizzas(at indexes: NSIndexSet)

    @objc(replaceObjectInPizzasAtIndex:withObject:)
    @NSManaged public func replacePizzas(at idx: Int, with value: Pizza)

    @objc(replacePizzasAtIndexes:withPizzas:)
    @NSManaged public func replacePizzas(at indexes: NSIndexSet, with values: [Pizza])

    @objc(addPizzasObject:)
    @NSManaged public func addToPizzas(_ value: Pizza)

    @objc(removePizzasObject:)
    @NSManaged public func removeFromPizzas(_ value: Pizza)

    @objc(addPizzas:)
    @NSManaged public func addToPizzas(_ values: NSOrderedSet)

    @objc(removePizzas:)
    @NSManaged public func removeFromPizzas(_ values: NSOrderedSet)

}
