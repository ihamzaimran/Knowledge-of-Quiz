//
//  QuizTableCell.swift
//  Quiz Of Knowledge
//
//  Created by Intern on 09/10/2020.
//

import UIKit

class QuizTableCell: UITableViewCell {

    @IBOutlet weak var quizCellImageView: UIImageView!
    @IBOutlet weak var quizCellCategoryLBL: UILabel!
    @IBOutlet weak var quizUIView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
