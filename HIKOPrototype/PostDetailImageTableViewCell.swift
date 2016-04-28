//
//  PostDetailImageTableViewCell.swift
//  HIKOPrototype
//
//  Created by Toshihiko Kubo on 2016/04/22.
//  Copyright © 2016年 Toshihiko Kubo. All rights reserved.
//

import UIKit

class PostDetailImageTableViewCell: UITableViewCell {
    @IBOutlet weak var backImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setBackImageView()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBackImageView() {
        backImageView.image = UIImage(named:"")
        backImageView.contentMode = UIViewContentMode.ScaleAspectFit
        backImageView.clipsToBounds = true
    }
    
}
