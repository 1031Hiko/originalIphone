//
//  CommentTableViewCell.swift
//  HIKOPrototype
//
//  Created by Toshihiko Kubo on 2016/04/22.
//  Copyright © 2016年 Toshihiko Kubo. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
