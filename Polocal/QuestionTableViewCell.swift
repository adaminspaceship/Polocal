//
//  QuestionTableViewCell.swift
//  Polocal
//
//  Created by Adam Eliezerov on 25/09/2018.
//  Copyright © 2018 Adam Eliezerov. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var falsePercentLabel: UILabel!
    @IBOutlet weak var truePercentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
