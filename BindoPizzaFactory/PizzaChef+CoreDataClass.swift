//
//  PizzaChef+CoreDataClass.swift
//  BindoPizzaFactory
//
//  Created by 李招雄 on 2020/3/6.
//  Copyright © 2020 李招雄. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PizzaChef)
public class PizzaChef: NSManagedObject {
    static var chefs: [PizzaChef] = []

    func update(name: String, time: Int64) {
        self.name = name
        self.time = time
    }    

    class func importPizzaChefsIntoDatabase() {
        let context = persistentContainer.viewContext
        context.perform {
            for i in 1...5 {
                guard let chef = NSEntityDescription.insertNewObject(forEntityName: "PizzaChef", into: context) as? PizzaChef else {
                    continue
                }
                let name = "Pizza Chef \(i-1)"
                chef.update(name: name, time: Int64(i))
                chefs.append(chef)
            }
            for i in 0...999 {
                guard let pizza = NSEntityDescription.insertNewObject(forEntityName: "Pizza", into: context) as? Pizza else {
                    continue
                }
                let name = String(format: "PIZZA_%04d", i)
                pizza.update(name: name)
                let chef = PizzaChef.chefs[i%PizzaChef.chefs.count]
                chef.addToPizzas(pizza)
            }
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                    return
                }
                // Reset the taskContext to free the cache and lower the memory footprint.
                context.reset()
            }
        }
    }

}
