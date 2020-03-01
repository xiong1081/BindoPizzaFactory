//
//  PizzaChefViewController.swift
//  BindoPizzaFactory
//
//  Created by 李招雄 on 2020/2/28.
//  Copyright © 2020 李招雄. All rights reserved.
//

import UIKit

class PizzaChefViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var remainLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var workSwitch: UISwitch!
    
    var chef: PizzaChef?
    var timer: Timer?
    var pizzaNumChanged: ((Int)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBorder()
        if let chef = chef {
            nameLabel.text = chef.name
            speedLabel.text = "Speed: \(chef.time) second per pizza"
            timer = Timer(fire: Date(), interval: TimeInterval(chef.time), repeats: true) { (timer) in
                if chef.pizzas.count == 0 {
                    timer.fireDate = Date.distantFuture
                } else {
                    let pizza = chef.pizzas.removeFirst()
                    pizza.completed = true
                    self.refreshUI()
                    if let changed = self.pizzaNumChanged {
                        changed(chef.pizzas.count)
                    }
                }
            }
            RunLoop.current.add(timer!, forMode: .common)
        }
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func refreshUI() {
        tableView.reloadData()
        refreshRemain()
    }
    
    func refreshRemain() {
        remainLabel.text = "Remaining Pizza: \(chef?.pizzas.count ?? 0)"
    }
    
    @IBAction func tapSwitch(_ sender: UISwitch) {
        resetFireDate()
    }
    
    func resetFireDate() {
        if workSwitch.isOn {
            let date = Date().addingTimeInterval(TimeInterval(chef?.time ?? 0))
            timer?.fireDate = date
        } else {
            timer?.fireDate = Date.distantFuture
        }
    }
    
    @IBAction func tapEdit(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "PizzaEditViewController")
        guard let pevc = vc as? PizzaEditViewController else { return }
        guard let cell = sender.superview?.superview as? PizzaTableViewCell else { return }
        pevc.popoverPresentationController?.sourceView = sender
        pevc.popoverPresentationController?.sourceRect = CGRect(x: 88, y: 22, width: 22, height: 22)
        pevc.pizza = cell.pizza
        show(pevc, sender: self)
    }
    
    @IBAction func tapDelegate(_ sender: UIButton) {
    }
    
}

extension PizzaChefViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chef?.pizzas.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PizzaTableViewCell") as! PizzaTableViewCell
        cell.pizza = chef?.pizzas[indexPath.row]
        return cell
    }
    
}
