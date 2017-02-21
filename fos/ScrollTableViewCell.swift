//
//  ScrollTableViewCell.swift
//  fos
//
//  Created by Karson Chau on 2017-02-13.
//  Copyright © 2017 Karson Chau. All rights reserved.
//

import UIKit

class ScrollTableViewCell: UITableViewCell {

    @IBOutlet weak var scollView: UIScrollView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
