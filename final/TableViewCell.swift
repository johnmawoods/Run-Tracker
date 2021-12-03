//
//  TableViewCell.swift
//  final
//
//  Created by John Woods on 11/14/21.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
