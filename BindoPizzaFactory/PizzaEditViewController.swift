//
//  PizzaEditViewController.swift
//  BindoPizzaFactory
//
//  Created by 李招雄 on 2020/2/29.
//  Copyright © 2020 李招雄. All rights reserved.
//

import UIKit

class PizzaEditViewController: UIViewController {
    
    let segmentControl = PizzaSegmentControl(pizzaSizes: PizzaSize.allCases)
    let sizeLabel = UILabel()
    let toppingsLabel = UILabel()
    
    let pizza: Pizza
    
    init(pizza: Pizza) {
        self.pizza = pizza
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .popover
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        preferredContentSize = CGSize(width: 333, height: 222)
        initSubviews()
    }
    
    // MARK: - Private
    
    private func initSubviews() {
        // SIZE
        sizeLabel.textColor = UIColor.gray
        sizeLabel.font = UIFont.boldSystemFont(ofSize: 10)
        sizeLabel.text = "SIZE"
        view.addSubview(sizeLabel)
        sizeLabel.addConstraints(attributes: [.left, .top], equalTo: view, inset: 30)
        // segmentControl
        if let size = PizzaSize(rawValue: pizza.size),
            let index = PizzaSize.allCases.firstIndex(of: size) {
            segmentControl.selectedIndex = index
        }
        segmentControl.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
        view.addSubview(segmentControl)
        segmentControl.addConstraint(attribute: .left, relatedBy: .equal, to: sizeLabel)
            .addConstraint(attribute: .top, relatedBy: .equal, to: sizeLabel, attribute: .bottom, constant: 15)
        // TOPPINGS
        toppingsLabel.textColor = UIColor.gray
        toppingsLabel.font = UIFont.boldSystemFont(ofSize: 10)
        toppingsLabel.text = "TOPPINGS"
        view.addSubview(toppingsLabel)
        toppingsLabel.addConstraint(attribute: .left, relatedBy: .equal, to: sizeLabel)
            .addConstraint(attribute: .top, relatedBy: .equal, to: segmentControl, attribute: .bottom, constant: 15)
        // ToppingControls
        var x: CGFloat = 30
        var y: CGFloat = 122
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
                x = 30
                y += height + 8
            } else {
                x += width + 8
            }
        }
    }
    
    private func createToppingControl() -> UIButton {
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
    
    // MARK: - Actions
    
    @objc func segmentControlValueChanged(_ sc: PizzaSegmentControl) {
        if pizza.completed {
            self.view.hint(title: "Sorry. Cannot modify a completed pizza.")
        } else {
            pizza.size = PizzaSize.allCases[sc.selectedIndex].rawValue
        }
    }
    
    @objc func tapTopping(button: UIButton) {
        if pizza.completed {
            self.view.hint(title: "Sorry. Cannot modify a completed pizza.")
        } else {
            button.isSelected = !button.isSelected
        }
    }

}
