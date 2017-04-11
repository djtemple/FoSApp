//
//  ScrollTableViewCell.swift
//  fos
//
//  Created by Karson Chau on 2017-02-13.
//  Copyright © 2017 Karson Chau. All rights reserved.
//

import UIKit

class ScrollTableViewCell: UITableViewCell {

    //@IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var imageArray = [UIImage]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageArray = [#imageLiteral(resourceName: "slide 1"), #imageLiteral(resourceName: "slide2"), #imageLiteral(resourceName: "slide1"), #imageLiteral(resourceName: "city_11"), #imageLiteral(resourceName: "city22")]
        
        print(imageArray.count)
        
        for i in 0..<imageArray.count {
            let iView = UIImageView()
            iView.image = imageArray[i]
            iView.contentMode = .scaleAspectFill
            
            print(self.scrollView.frame.width)
            let xPosition = self.scrollView.frame.width * CGFloat(i)
            iView.frame = CGRect(x: xPosition, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            scrollView.addSubview(iView)
            
        }
        Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
    }
    
    func moveToNextPage() {
        
        let pageWidth:CGFloat = self.scrollView.frame.width
        let maxWidth:CGFloat = pageWidth * CGFloat(self.imageArray.count)
        let contentOffset:CGFloat = self.scrollView.contentOffset.x
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth
        {
            slideToX = 0
        }
        
        self.scrollView.setContentOffset(CGPoint(x: slideToX, y: 0), animated: true)
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
