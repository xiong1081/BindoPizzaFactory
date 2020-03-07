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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBorder()
        tableView.separatorStyle = .none
        if let chef = chef {
            nameLabel.text = chef.name
            speedLabel.text = "Speed: \(chef.time) second per pizza"
        }
        tableView.reloadData()
        NotificationCenter.default.addObserver(forName: NSNotification.Name.PizzaChefFinishPizza, object: nil, queue: nil) { (noti) in
            guard let chef = noti.object as? PizzaChef, chef == self.chef else { return }
            self.tableView.reloadData()
            self.resetRemainLabel()
        }
        chef?.startWorking()
//        DispatchQueue.main.async {
//            NotificationCenter.default.post(name: NSNotification.Name.PizzaChefAddPizzas, object: self, userInfo: ["pizzas": pizzas])
//        }
    }
    
    func resetRemainLabel() {
        remainLabel.text = "Remaining Pizza: \(chef?.remainCount ?? 0)"
    }
    
    @IBAction func tapSwitch(_ sender: UISwitch) {
        chef?.workQueue.isSuspended = !workSwitch.isOn
    }
    
    @IBAction func tapEdit(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? PizzaTableViewCell,
            let pizza = cell.pizza else { return }
        let pevc = PizzaEditViewController(pizza: pizza)
        pevc.popoverPresentationController?.sourceView = sender
        pevc.popoverPresentationController?.sourceRect = sender.bounds
        show(pevc, sender: self)
    }
    
    @IBAction func tapDelegate(_ sender: UIButton) {
    }
    
}

extension PizzaChefViewController: UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chef?.pizzas.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PizzaTableViewCell") as! PizzaTableViewCell
        cell.pizza = chef?.pizzas[indexPath.row] as? Pizza
        return cell
    }
    
}
