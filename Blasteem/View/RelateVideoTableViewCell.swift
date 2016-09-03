//
//  RelateVideoTableViewCell.swift
//  Blasteem
//
//  Created by k on 8/25/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class RelateVideoTableViewCell: UITableViewCell {

    @IBOutlet weak var creator_nameLabel: UILabel!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var view_countLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var blast_countLabel: UILabel!
    //Model
    var video:VideoModel?
    var video_index:Int?
    
    var homeVC:VideoDetailViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell() {
        
        self.videoImage.sd_setImageWithURL(NSURL(string: (video?.video_image)!))
        self.creator_nameLabel.text = video?.creator?.name
        
        if let count1 = video?.view_count {
            self.view_countLabel.text = AppUtil.getStringFromInt(count1)
        }
        if let count2 = video?.blast_count {
            self.blast_countLabel.text = AppUtil.getStringFromInt(count2)
        }
        if let post_content = video?.post_title {
            videoTitle.text = post_content
        }
        if let post_date =  video?.post_date
        {
            let localIdentifier = "it_IT"
            let locale = NSLocale(localeIdentifier: localIdentifier)
            let dateformatter = NSDateFormatter()
            dateformatter.locale = locale
            dateformatter.dateFormat = "dd MMMM yyyy"
            if let date = NSDate(fromString: post_date, withFormat: "yyyy-MM-dd HH:mm:ss") {
                let local_date = dateformatter.stringFromDate(date)
                self.dateLabel.text = local_date
            }
            
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
