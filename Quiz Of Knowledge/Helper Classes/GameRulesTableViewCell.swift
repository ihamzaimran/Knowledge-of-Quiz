//
//  GameRulesTableViewCell.swift
//  Quiz Of Knowledge
//
//  Created by Intern on 09/10/2020.
//

import UIKit

class GameRulesTableViewCell: UITableViewCell {

    @IBOutlet weak var gameRulesImageView: UIImageView!
    @IBOutlet weak var gameRulesDescLBL: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
