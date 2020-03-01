//
//  ViewController.swift
//  BindoPizzaFactory
//
//  Created by 李招雄 on 2020/2/28.
//  Copyright © 2020 李招雄. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    let chefCount = 5
    var pizzaId: Int = 0
    var viewControllers: [PizzaChefViewController] = []
    var summaryLabels: [UILabel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        summaryView.addBorder()
        for view in bottomStackView.arrangedSubviews {
            view.addBorder()
        }
        for i in 1...chefCount {
            let name = "Pizza Chef \(i-1)"
            let chef = PizzaChef(name: name, time: i)
            let viewController = storyboard?.instantiateViewController(identifier: "PizzaChefViewController")
            if let pizzaChefVC = viewController as? PizzaChefViewController {
                pizzaChefVC.chef = chef
                addChild(pizzaChefVC)
                stackView.addArrangedSubview(pizzaChefVC.view)
                pizzaChefVC.didMove(toParent: self)
                viewControllers.append(pizzaChefVC)
                pizzaChefVC.pizzaNumChanged = { [weak self] count in
                    self?.summaryLabels[i-1].text = "\(name): \(count)"
                }
            }
            // summary
            let width = 130
            let height = 35
            let x = 8 + width * ((i-1) % 3)
            let y = 45 + height * ((i-1) / 3)
            let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
            label.font = UIFont.systemFont(ofSize: 12)
            summaryView.addSubview(label)
            summaryLabels.append(label)
        }
        for i in 0...999 {
            pizzaId += 1
            let name = String(format: "PIZZA_%04d", pizzaId)
            let pizza = Pizza(name: name)
            viewControllers[i%5].chef?.pizzas.append(pizza)
        }
    }
    
    func refreshSummaryLabel(viewController: PizzaChefViewController, index: Int) {
        let name = viewController.nameLabel.text ?? ""
        let count = viewController.chef?.pizzas.count ?? 0
        self.summaryLabels[index].text = "\(name): \(count)"
    }

    @IBAction func tapSwitch(_ sender: UISwitch) {
        for pcvc in viewControllers {
            pcvc.workSwitch.isOn = sender.isOn
            pcvc.resetFireDate()
        }
    }
    
    @IBAction func add10Pizza(_ sender: UIButton) {
        addPizza(count: 10)
    }
    
    @IBAction func add100Pizza(_ sender: UIButton) {
        addPizza(count: 100)
    }
    
    func addPizza(count: Int) {
        for i in 0..<count {
            pizzaId += 1
            let name = String(format: "PIZZA_%04d", pizzaId)
            let pizza = Pizza(name: name)
            viewControllers[i%chefCount].chef?.pizzas.append(pizza)
        }
        for (i, pcvc) in viewControllers.enumerated() {
            self.refreshSummaryLabel(viewController: pcvc, index: i)
            pcvc.refreshUI()
            pcvc.timer?.fireDate = Date()
        }
    }
    
}

