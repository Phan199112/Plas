//
//  CategoryDetailTableViewCell.swift
//  Blasteem
//
//  Created by k on 8/22/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class CategoryDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var creator_nameLabel: UILabel!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var view_countLabel: UILabel!
    
    //Model
    var video:VideoModel?
    var video_index:Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell() {
        if video_index! % 2 == 0 {
            self.contentView.backgroundColor = UIColor.whiteColor()
        }else{
                self.contentView.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        }
        if let video_image = video?.video_image
        {
            self.videoImage.sd_setImageWithURL(NSURL(string: video_image))
        }
        if let video_title = video?.post_title {
            self.videoTitle.text = video_title
        }
        self.creator_nameLabel.text = video?.creator?.name
        
        if let count = video?.view_count {
            self.view_countLabel.text = String(count)
        }
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
