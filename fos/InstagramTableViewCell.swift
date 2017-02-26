//
//  InstagramTableViewCell.swift
//  fos
//
//  Created by Karson Chau on 2017-02-26.
//  Copyright © 2017 Karson Chau. All rights reserved.
//

import UIKit

class InstagramTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var instagramImage: UIImageView!
    
    @IBOutlet weak var textDescriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        instagramImage.image = UIImage(named: "instagramLogo")
        postImage.image = UIImage(named: "cannot load image")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
