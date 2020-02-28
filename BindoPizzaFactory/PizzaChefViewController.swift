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
    
    var chef: PizzaChef?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBorder()
    }
    
    @IBAction func tapSwitch(_ sender: UISwitch) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
