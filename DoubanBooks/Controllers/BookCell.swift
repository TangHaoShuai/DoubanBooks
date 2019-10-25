//
//  BookCell.swift
//  DoubanBooks
//
//  Created by 2017yd2 on 2019/10/24.
//  Copyright © 2019 2017yd. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {

    
    @IBOutlet weak var bookimg: UIImageView!
    
    @IBOutlet weak var bookname: UILabel!
    
    @IBOutlet weak var authornama: UILabel!
    
    @IBOutlet weak var introduce: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
