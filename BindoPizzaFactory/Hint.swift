//
//  Hint.swift
//  BindoPizzaFactory
//
//  Created by 李招雄 on 2020/3/1.
//  Copyright © 2020 李招雄. All rights reserved.
//

import UIKit

fileprivate let nib = UINib(nibName: "Hint", bundle: nil)
fileprivate let views = nib.instantiate(withOwner: nil, options: nil)

class Hint: UIView {
    @IBOutlet weak var label: UILabel!
    
    static let shared = views.first as! Hint
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 4
        clipsToBounds = true
    }
}

extension UIView {
    
    func hint(title: String) {
        Hint.shared.label.text = title
        self.addSubview(Hint.shared)
        Hint.shared.addConstraints(attributes: [.centerX, .centerY], equalTo: self)
        Hint.shared.perform(#selector(removeFromSuperview), with: nil, afterDelay: 2)
    }
    
}
