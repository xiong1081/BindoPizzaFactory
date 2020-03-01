//
//  PizzaEditViewController.swift
//  BindoPizzaFactory
//
//  Created by 李招雄 on 2020/2/29.
//  Copyright © 2020 李招雄. All rights reserved.
//

import UIKit

class PizzaEditViewController: UIViewController {
    
    var segmentControl: SegmentControl?
    
    var pizza: Pizza?
    var modify: ((Pizza) -> ())?
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var toppingsLabel: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        navItem.title = pizza?.name
        // SIZE
        segmentControl = SegmentControl()
        for size in PizzaSize.allCases {
            segmentControl!.add(item: (size.rawValue, size.weight))
        }
        if let pizza = pizza, let index = PizzaSize.allCases.firstIndex(of: pizza.size) {
            segmentControl!.selectedIndex = index
        }
        segmentControl?.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
        view.addSubview(segmentControl!)
        segmentControl!.addConstraint(attribute: .left, relatedBy: .equal, to: sizeLabel)
            .addConstraint(attribute: .top, relatedBy: .equal, to: sizeLabel, attribute: .bottom, constant: 18)
        // TOPPINGS
        var x: CGFloat = 15
        var y: CGFloat = 180
        for (i, item) in PizzaToppings.allCases.enumerated() {
            let button = createToppingControl()
            let attributes = [NSAttributedString.Key.font : button.titleLabel!.font!]
            let rect = item.description.boundingRect(with: CGSize(width: Int.max, height: 20), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            let width = rect.size.width + 16
            let height: CGFloat = 22
            button.frame = CGRect(x: x, y: y, width: width, height: height)
            button.setTitle(item.description, for: .normal)
            view.addSubview(button)
            if i % 3 == 2 {
                x = 15
                y += height + 8
            } else {
                x += width + 8
            }
        }
    }
    
    @objc func segmentControlValueChanged(_ sc: SegmentControl) {
        pizza?.size = PizzaSize.allCases[sc.selectedIndex]
    }
    
    @IBAction func tapDismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapDone(_ sender: UIBarButtonItem) {
        guard let pizza = pizza else { return }
        if pizza.completed {
            self.view.hint(title: "Sorry. Cannot modify a completed pizza.")
        } else {
            self.dismiss(animated: true, completion: nil)
            if let m = modify {
                m(pizza)
            }
        }
    }
    
    func createToppingControl() -> UIButton {
        let control = UIButton()
        control.layer.cornerRadius = 11
        control.clipsToBounds = true
        control.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        control.setTitleColor(UIColor.label, for: .normal)
        control.addTarget(self, action: #selector(tapTopping(button:)), for: .touchUpInside)
        control.setBackgroundImage(UIImage.image(of: UIColor.background), for: .normal)
        control.setBackgroundImage(UIImage.image(of: UIColor.selectedBackground), for: .selected)
        return control
    }
    
    @objc func tapTopping(button: UIButton) {
        button.isSelected = !button.isSelected
    }

}
