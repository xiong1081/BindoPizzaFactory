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
    var remainCount: Int = 0
    let workQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    func update(name: String, time: Int64) {
        self.name = name
        self.time = time
    }
    
    func initWorks() {
        remainCount = pizzas.count
        for (i, pizza) in pizzas.enumerated() {
            guard let pizza = pizza as? Pizza,
                pizza.completed == false else {
                remainCount -= 1
                continue
            }
            workQueue.addOperation { [weak self] in
                sleep(UInt32(self!.time))
                pizza.completed = true
                DispatchQueue.main.async {
                    self?.remainCount -= 1
                    NotificationCenter.default.post(name: NSNotification.Name.PizzaChefFinishPizza, object: self, userInfo: ["index": i])
                }
            }
        }
    }
    
    func add(pizzas: [Pizza]) {
        addToPizzas(NSOrderedSet(array: pizzas))
        remainCount += pizzas.count
        for pizza in pizzas {
            workQueue.addOperation { [weak self] in
                sleep(UInt32(self!.time))
                pizza.completed = true
            }
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name.PizzaChefAddPizzas, object: self, userInfo: ["pizzas": pizzas])
        }
    }
    
    class func importPizzaChefsIntoDatabase() {
        let context = persistentContainer.viewContext
        context.perform {
            var pizzass:[[Pizza]] = Array(repeating: [], count: 5)
            for i in 0...999 {
                guard let pizza = NSEntityDescription.insertNewObject(forEntityName: "Pizza", into: context) as? Pizza else {
                    continue
                }
                let name = String(format: "PIZZA_%04d", i)
                pizza.update(name: name)
                pizzass[i%pizzass.count].append(pizza)
            }
            for i in 1...pizzass.count {
                guard let chef = NSEntityDescription.insertNewObject(forEntityName: "PizzaChef", into: context) as? PizzaChef else {
                    continue
                }
                let name = "Pizza Chef \(i-1)"
                chef.update(name: name, time: Int64(i))
                chef.add(pizzas: pizzass[i-1])
            }
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                    return
                }
            }
        }
    }

}
