//
//  Extension.swift
//  Demo
//
//  Created by 李招雄 on 2020/2/23.
//  Copyright © 2020 李招雄. All rights reserved.
//

import UIKit

extension UIColor {
    
    @objc convenience init(hex: UInt32) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
    
    class var line: UIColor { UIColor(named: "line")! }
    class var background: UIColor { UIColor(named: "background")! }
    class var selectedBackground: UIColor { UIColor(named: "selectedBackground")! }

}

extension UIView {
    
    @discardableResult
    func addConstraint(attribute attr1: NSLayoutConstraint.Attribute,
                       relatedBy relation: NSLayoutConstraint.Relation,
                       to view: UIView? = nil,
                       attribute attr2: NSLayoutConstraint.Attribute? = nil,
                       multiplier: CGFloat = 1,
                       constant: CGFloat = 0) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: attr1, relatedBy: relation, toItem: view, attribute: attr2 ?? attr1, multiplier: multiplier, constant: constant)
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func addConstraints(attributes: [NSLayoutConstraint.Attribute],
                        equalTo view: UIView,
                        inset: CGFloat = 0) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        var constraints: [NSLayoutConstraint] = []
        for attribute in attributes {
            var constant = inset
            if attribute == .right || attribute == .bottom {
                constant = -inset
            }
            let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: 1, constant: constant)
            constraints.append(constraint)
        }
        NSLayoutConstraint.activate(constraints)
        return self
    }
    
    func addBorder() {
        self.layer.borderColor = CGColor(genericGrayGamma2_2Gray: 0.8, alpha: 1)
        self.layer.borderWidth = 0.5
    }
    
}

extension UIImage {
    class func image(of color: UIColor) -> UIImage {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension NSNotification.Name {
    static let PizzaChefFinishPizza = NSNotification.Name(rawValue: "PizzaChefFinishPizza")
}
