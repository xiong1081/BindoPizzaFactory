//
//  ViewController.swift
//  BindoPizzaFactory
//
//  Created by 李招雄 on 2020/2/28.
//  Copyright © 2020 李招雄. All rights reserved.
//

import UIKit
import CoreData
import Network

class ViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    var viewControllers: [PizzaChefViewController] = []
    var summaryLabels: [UILabel] = []
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var passcodeLabel: UILabel!
    
    var results: [NWBrowser.Result] = [NWBrowser.Result]()
    var name: String = "Default"
    var passcode = String("\(Int.random(in: 0...9))\(Int.random(in: 0...9))\(Int.random(in: 0...9))\(Int.random(in: 0...9))")
    var delegatePizza: Pizza?
    
    // MARK: Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PizzaChef.fetchedResultsController.delegate = self
        do {
            try PizzaChef.fetchedResultsController.performFetch()
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
                let objects = PizzaChef.fetchedResultsController.fetchedObjects,
                let i = objects.firstIndex(of: chef) else { return }
            self.summaryLabels[i].text = "\(chef.name): \(chef.remainCount)"
        }
        sharedBrowser = PeerBrowser(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let imported = UserDefaults.standard.bool(forKey: "ImportPizzaChefsIntoDatabase")
        if imported {
            
        } else {
            UserDefaults.standard.set(true, forKey: "ImportPizzaChefsIntoDatabase")
            PizzaChef.importPizzaChefsIntoDatabase()
        }
    }
    
    func addChildControllersAndSummaryLabels() {
        guard let objects = PizzaChef.fetchedResultsController.fetchedObjects else { return }
        let width = 130
        let height = 35
        for (i, chef) in objects.enumerated() {
            let viewController = storyboard?.instantiateViewController(identifier: "PizzaChefViewController")
            if let pizzaChefVC = viewController as? PizzaChefViewController {
                pizzaChefVC.chef = chef
                pizzaChefVC.delegate = self
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
    
    // MARK: Actions

    @IBAction func tapSwitch(_ sender: UISwitch) {
        for pcvc in viewControllers {
            pcvc.workSwitch.isOn = sender.isOn
            pcvc.chef?.workQueue.isSuspended = !pcvc.workSwitch.isOn
        }
    }
    
    @IBAction func add10Pizza(_ sender: UIButton) {
        PizzaChef.addPizzas(count: 10)
    }
    
    @IBAction func add100Pizza(_ sender: UIButton) {
        PizzaChef.addPizzas(count: 100)
    }
    
    @IBAction func tapHost(_ sender: UIButton) {
        view.endEditing(true)
        guard let name = textField.text, !name.isEmpty else { return }
        if let listener = sharedListener {
            // If your app is already listening, just update the name.
            listener.resetName(name)
        } else {
            // If your app is not yet listening, start a new listener.
            sharedListener = PeerListener(name: name, passcode: passcode, delegate: self)
        }
        passcodeLabel.text = passcode
    }
    
}

extension ViewController: NSFetchedResultsControllerDelegate, PizzaChefDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if viewControllers.count == 0 {
            addChildControllersAndSummaryLabels()
        } else {
            for (i, pcvc) in self.viewControllers.enumerated() {
                guard let chef = pcvc.chef else { return }
                self.summaryLabels[i].text = "\(chef.name): \(chef.remainCount)"
                pcvc.tableView.reloadData()
                pcvc.resetRemainLabel()
            }
        }
    }
    
    func delegate(chef: PizzaChef, pizza: Pizza, button: UIButton) {
        guard results.count > 0 else { return }
        delegatePizza = pizza
        if sharedConnection == nil {
            alertChooseFactory(button: button)
        } else {
            sendPizza()
        }
    }
    
    func sendPizza() {
        guard let pizza = delegatePizza else { return }
        guard pizza.completed == false else {
            self.view.hint(title: "\(pizza.name) has been completed.")
            return
        }
        let message = NWProtocolFramer.Message(gameMessageType: .sendPizza)
        let context = NWConnection.ContentContext(identifier: "name",
                                                  metadata: [message])
        sharedConnection?.connection?.send(content: pizza.name.data(using: .utf8), contentContext: context, isComplete: true, completion: .idempotent)
    }
    
    func alertChooseFactory(button: UIButton) {
        let alert = UIAlertController(title: nil, message: "选择代理工厂", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = button
        alert.popoverPresentationController?.sourceRect = button.bounds
        for item in results {
            if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = item.endpoint {
                let action = UIAlertAction(title: name, style: .default) { (a) in
                    self.alertPasscode(result: item, name: name)
                }
                alert.addAction(action)
            }
        }
        show(alert, sender: nil)
    }
    
    func alertPasscode(result: NWBrowser.Result, name: String) {
        let alert = UIAlertController(title: "连接到【\(name)】", message: nil, preferredStyle: .alert)
        var textField: UITextField?
        alert.addTextField { (tf) in
            tf.placeholder = "请输入密码"
            textField = tf
        }
        let action = UIAlertAction(title: "确定", style: .default) { (a) in
            if let passcode = textField?.text {
                sharedConnection = PeerConnection(endpoint: result.endpoint, interface: result.interfaces.first, passcode: passcode, delegate: self)
            }
        }
        alert.addAction(action)
        show(alert, sender: nil)
    }
}

extension ViewController: PeerConnectionDelegate, PeerBrowserDelegate {
    // When a connection becomes ready, move into game mode.
    func connectionReady() {
        sendPizza()
//        sharedConnection?.cancel()
//        sharedConnection = nil
    }

    // Ignore connection failures and messages prior to starting a game.
    func connectionFailed() { }
    
    func receivedMessage(content: Data?, message: NWProtocolFramer.Message) {
        guard let content = content,
            let name = String(data: content, encoding: .utf8) else {
            return
        }
        switch message.gameMessageType {
        case .receivedPizza:
            self.view.hint(title: "Sended \(name)")
            guard let pizza = delegatePizza else { break }
            pizza.chef.removeFromPizzas(pizza)
        case .sendPizza:
            guard let chefs = PizzaChef.fetchedResultsController.fetchedObjects else { return }
            let index = Int.random(in: 0..<chefs.count)
            chefs[index].receivePizzaFromOtherFactory(name: name)
            self.view.hint(title: "\(chefs[index].name) received \(name)")
            // 回复“收到”
            let message = NWProtocolFramer.Message(gameMessageType: .receivedPizza)
            let context = NWConnection.ContentContext(identifier: "name",
                                                      metadata: [message])
            sharedConnection?.connection?.send(content: name.data(using: .utf8), contentContext: context, isComplete: true, completion: .idempotent)
        default:
            print("Received other message.")
        }
    }
    
    // When the discovered peers change, update the list.
    func refreshResults(results: Set<NWBrowser.Result>) {
        self.results = [NWBrowser.Result]()
        for result in results {
            if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = result.endpoint {
                if name != self.name {
                    self.results.append(result)
                }
            }
        }
    }
}
