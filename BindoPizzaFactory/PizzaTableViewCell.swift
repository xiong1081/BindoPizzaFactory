//
//  PizzaTableViewCell.swift
//  BindoPizzaFactory
//
//  Created by 李招雄 on 2020/2/28.
//  Copyright © 2020 李招雄. All rights reserved.
//

import UIKit

class PizzaTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var delegateButton: UIButton!
    
    var pizza: Pizza? {
        didSet {
            nameLabel.text = pizza?.name
            if let completed = pizza?.completed {
                if completed {
                    accessoryType = .checkmark
                    editButton.isHidden = true
                    delegateButton.isHidden = true
                } else {
                    accessoryType = .none
                    editButton.isHidden = false
                    delegateButton.isHidden = false
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func tapEdit(_ sender: UIButton) {
    }
    
    @IBAction func tapDelegate(_ sender: UIButton) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
