//
//  PizzaEditViewController.swift
//  BindoPizzaFactory
//
//  Created by 李招雄 on 2020/2/29.
//  Copyright © 2020 李招雄. All rights reserved.
//

import UIKit

class PizzaEditViewController: UIViewController {
    
    let sizes = [PizzaSize.small, .medium, .large]
    var segmentControl: SegmentControl?
    
    var pizza: Pizza?
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var toppingsLabel: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        navItem.title = pizza?.name
        segmentControl = SegmentControl()
        for size in sizes {
            segmentControl!.add(item: (size.rawValue, size.weight))
        }
        if let pizza = pizza, let index = sizes.firstIndex(of: pizza.size) {
            segmentControl!.selectedIndex = index
        }
        segmentControl?.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
        view.addSubview(segmentControl!)
        segmentControl!.addConstraint(attribute: .left, relatedBy: .equal, to: sizeLabel)
            .addConstraint(attribute: .top, relatedBy: .equal, to: sizeLabel, attribute: .bottom, constant: 18)
    }
    
    @objc func segmentControlValueChanged(_ sc: SegmentControl) {
        pizza?.size = sizes[sc.selectedIndex]
    }
    
    @IBAction func tapDismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapDone(_ sender: UIBarButtonItem) {
        guard let pizza = pizza else { return }
        if pizza.completed {
            self.view.hint(title: "Sorry. Cannot modify a completed pizza.")
        } else {
            
        }
    }
    
    func createToppingControl() -> UIButton {
        let control = UIButton()
        control.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        control.setTitleColor(UIColor.label, for: .normal)
        control.setBackgroundImage(UIImage.image(of: UIColor.background), for: .normal)
        control.setBackgroundImage(UIImage.image(of: UIColor.selectedBackground), for: .selected)
        return control
    }

}
