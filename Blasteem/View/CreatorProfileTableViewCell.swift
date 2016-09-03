//
//  CreatorProfileTableViewCell.swift
//  Blasteem
//
//  Created by k on 8/28/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class CreatorProfileTableViewCell: UITableViewCell {

    
    @IBOutlet weak var view_count: UILabel!
    @IBOutlet weak var motherView: UIView!
    @IBOutlet weak var contentImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var homeVC:HomeViewController?
    var video:VideoModel?{
        didSet{
            self.configureCell()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell() {
        if let videoimage = video?.video_image {
            self.contentImageView.sd_setImageWithURL(NSURL(string: videoimage))
        }
        
        self.titleLabel.text = video?.post_title?.uppercaseString
        if let count = video?.view_count {
            self.view_count.text = AppUtil.getStringFromInt(count)
        }
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
