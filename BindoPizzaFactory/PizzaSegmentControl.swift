//
//  SegmentControl.swift
//  BindoPizzaFactory
//
//  Created by 李招雄 on 2020/2/29.
//  Copyright © 2020 李招雄. All rights reserved.
//

import UIKit

class PizzaSegmentItem: UIView {
    let titleLabel = UILabel()
    let weightLabel = UILabel()

    init(title: String, weight: Int) {
        super.init(frame: .zero)
        isUserInteractionEnabled = false
        backgroundColor = UIColor.background
        titleLabel.font = UIFont.boldSystemFont(ofSize: 11)
        titleLabel.text = title
        addSubview(titleLabel)
        titleLabel.addConstraint(attribute: .left, relatedBy: .equal, to: self, constant: 8)
            .addConstraints(attributes: [.centerY], equalTo: self)
        weightLabel.font = UIFont.boldSystemFont(ofSize: 10)
        weightLabel.textColor = UIColor.gray
        weightLabel.text = "\(weight)g"
        addSubview(weightLabel)
        weightLabel.addConstraints(attributes: [.centerY], equalTo: self)
            .addConstraint(attribute: .left, relatedBy: .equal, to: titleLabel, attribute: .right, constant: 4)
            .addConstraint(attribute: .right, relatedBy: .equal, to: self, constant: -8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PizzaSegmentControl: UIControl {
    let pizzaSizes: [PizzaSize]
    let stackView = UIStackView()
    let height: CGFloat = 20

    private var trackingItem: PizzaSegmentItem?
    private(set) var selectedItem: PizzaSegmentItem?
    
    var selectedIndex: Int {
        get {
            if let selectedItem = selectedItem,
                let index = stackView.arrangedSubviews.firstIndex(of: selectedItem) {
                return index
            } else {
                return UISegmentedControl.noSegment
            }
        }
        set(index) {
            guard stackView.arrangedSubviews.count > index else {
                return
            }
            let item = stackView.arrangedSubviews[index] as! PizzaSegmentItem
            select(item)
        }
    }
        
    init(pizzaSizes: [PizzaSize]) {
        self.pizzaSizes = pizzaSizes
        super.init(frame: .zero)
        addConstraint(attribute: .height, relatedBy: .equal, constant: height)
        layer.cornerRadius = height / 2
        clipsToBounds = true
        initSubviews()
    }
    
    private func initSubviews() {
        for pizzaSize in pizzaSizes {
            let item = PizzaSegmentItem(title: pizzaSize.rawValue, weight: pizzaSize.weight)
            stackView.addArrangedSubview(item)
        }
        stackView.isUserInteractionEnabled = false
        addSubview(stackView)
        stackView.addConstraints(attributes: [.top, .left, .bottom, .right], equalTo: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        for item in stackView.arrangedSubviews {
            let point = touch.location(in: item)
            if item.point(inside: point, with: event) {
                trackingItem = (item as! PizzaSegmentItem)
                break
            }
        }
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        guard let ti = trackingItem, let touch = touch else { return }
        let point = touch.location(in: ti)
        if ti.point(inside: point, with: event) {
            select(ti)
            trackingItem = nil
            sendActions(for: .valueChanged)
        }
    }
    
    override func cancelTracking(with event: UIEvent?) {
        trackingItem = nil
    }
    
    func select(_ item: PizzaSegmentItem) {
        if selectedItem != nil {
            selectedItem?.backgroundColor = UIColor.background
        }
        item.backgroundColor = UIColor.selectedBackground
        selectedItem = item
    }
    
}
