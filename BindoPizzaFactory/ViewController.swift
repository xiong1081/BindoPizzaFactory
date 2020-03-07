//
//  ViewController.swift
//  BindoPizzaFactory
//
//  Created by 李招雄 on 2020/2/28.
//  Copyright © 2020 李招雄. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    var viewControllers: [PizzaChefViewController] = []
    var summaryLabels: [UILabel] = []
    
    lazy var fetchedResultsController: NSFetchedResultsController<PizzaChef> = {
        let fetchRequest = NSFetchRequest<PizzaChef>(entityName: "PizzaChef")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        // Create a fetched results controller and set its fetch request, context, and delegate.
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imported = UserDefaults.standard.bool(forKey: "ImportPizzaChefsIntoDatabase")
        if imported {
            
        } else {
            UserDefaults.standard.set(true, forKey: "ImportPizzaChefsIntoDatabase")
            PizzaChef.importPizzaChefsIntoDatabase()
        }
        do {
            try fetchedResultsController.performFetch()
            addChildControllersAndSummaryLabels()
        } catch {
            fatalError("Unresolved error \(error)")
        }
        summaryView.addBorder()
        for view in bottomStackView.arrangedSubviews {
            view.addBorder()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.PizzaChefFinishPizza, object: nil, queue: nil) { (noti) in
            guard let chef = noti.object as? PizzaChef,
                let objects = self.fetchedResultsController.fetchedObjects,
                let i = objects.firstIndex(of: chef) else { return }
            self.summaryLabels[i].text = "\(chef.name): \(chef.remainCount)"
        }
    }
    
    func addChildControllersAndSummaryLabels() {
        guard let objects = fetchedResultsController.fetchedObjects else { return }
        let width = 130
        let height = 35
        for (i, chef) in objects.enumerated() {
            let viewController = storyboard?.instantiateViewController(identifier: "PizzaChefViewController")
            if let pizzaChefVC = viewController as? PizzaChefViewController {
                pizzaChefVC.chef = chef
                addChild(pizzaChefVC)
                stackView.addArrangedSubview(pizzaChefVC.view)
                pizzaChefVC.didMove(toParent: self)
                viewControllers.append(pizzaChefVC)
            }
            // summary
            let x = 8 + width * (i % 3)
            let y = 45 + height * (i / 3)
            let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
            label.font = UIFont.systemFont(ofSize: 12)
            label.text = "\(chef.name): \(chef.pizzas.count)"
            summaryView.addSubview(label)
            summaryLabels.append(label)
        }
    }

    @IBAction func tapSwitch(_ sender: UISwitch) {
        for pcvc in viewControllers {
            pcvc.workSwitch.isOn = sender.isOn
            pcvc.chef?.workQueue.isSuspended = !pcvc.workSwitch.isOn
        }
    }
    
    @IBAction func add10Pizza(_ sender: UIButton) {
        addPizza(count: 10)
    }
    
    @IBAction func add100Pizza(_ sender: UIButton) {
        addPizza(count: 100)
    }
    
    func addPizza(count: Int) {
        var pizzass:[[Pizza]] = Array(repeating: [], count: viewControllers.count)
        for i in 0..<count {
            guard let pizza = NSEntityDescription.insertNewObject(forEntityName: "Pizza", into: persistentContainer.viewContext) as? Pizza else { continue }
            let name = String(format: "PIZZA_%04d", arc4random()%10000)
            pizza.update(name: name)
            pizzass[i%viewControllers.count].append(pizza)
        }
        for (i, pcvc) in viewControllers.enumerated() {
            pcvc.tableView.reloadData()
            pcvc.resetRemainLabel()
            if let chef = pcvc.chef {
                chef.add(pizzas: pizzass[i])
                self.summaryLabels[i].text = "\(chef.name): \(chef.remainCount)"
            }
        }
    }
    
}

extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if viewControllers.count == 0 {
            addChildControllersAndSummaryLabels()
        }
    }
    
}
