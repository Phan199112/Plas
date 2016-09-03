//
//  FilterView.swift
//  Blasteem
//
//  Created by k on 8/21/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class FilterView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var isSelected:Bool = false{
        didSet{
            if isSelected {
                self.selectedState()
            }else{
                self.unSelectedState()
            }
        }
    }
    var image_name:String?{
        didSet{
            imageView.image = UIImage(named: image_name!)
        }
    }
    var title:String?{
        didSet{
            label.text = title!
        }
    }
    
    private var imageView:UIImageView = UIImageView()
    private var label:UILabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = mainColor
        
        imageView.frame = CGRectMake((frame.size.width - 20) / 2, 14, 20, 20)
        imageView.contentMode = .ScaleAspectFit
        label.frame = CGRectMake(0, 40, frame.size.width, 20)
        label.textAlignment = .Center
        label.font = AppFont.OpenSans_12
        label.textColor = UIColor.whiteColor()
        
        self.addSubview(imageView)
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectedState() {
        self.backgroundColor = UIColor.whiteColor()
        self.imageView.image = UIImage(named: image_name! + "_selected")
        self.label.textColor = mainColor
    }
    
    func unSelectedState() {
        self.backgroundColor = UIColor.clearColor()
        self.imageView.image = UIImage(named: image_name!)
        self.label.textColor = UIColor.whiteColor()
    }
}
