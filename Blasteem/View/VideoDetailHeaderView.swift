//
//  VideoDetailHeaderView.swift
//  Blasteem
//
//  Created by k on 8/25/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class VideoDetailHeaderView: UIView {
    var isBlasted:Bool?
    
    @IBOutlet weak var blastButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!

    @IBOutlet weak var like_countLabel: UILabel!
    @IBOutlet weak var heightConstraints: NSLayoutConstraint!
    @IBOutlet weak var blast_countLabel: UILabel!
    @IBOutlet weak var postContentTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    
}
