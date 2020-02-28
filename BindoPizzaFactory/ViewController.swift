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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        summaryView.addBorder()
        for view in bottomStackView.arrangedSubviews {
            view.addBorder()
        }
        for i in 0...6 {
            let chef = PizzaChef(name: "Pizza Chef \(i)", time: i+1)
            let viewController = storyboard?.instantiateViewController(identifier: "PizzaChefViewController")
            if let pizzaChefVC = viewController as? PizzaChefViewController {
                pizzaChefVC.chef = chef
                addChild(pizzaChefVC)
                stackView.addArrangedSubview(pizzaChefVC.view)
                pizzaChefVC.didMove(toParent: self)
            }
        }
    }

}

