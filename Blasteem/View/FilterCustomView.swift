//
//  FilterCustomView.swift
//  Blasteem
//
//  Created by k on 8/21/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

enum FilterMenu {
    case Latest
    case Visit
    case Top
}

protocol FilterViewDelegate {
    func filterChanged(menu:FilterMenu) -> Void
}

class FilterCustomView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var delegate:FilterViewDelegate?
    var oldState:FilterMenu?
    
    var new_view:FilterView?
    var visit_view:FilterView?
    var top_view:FilterView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = mainColor
        
        new_view = FilterView(frame:CGRectMake(0, 4, frame.width / 3.0, frame.height - 5))
        visit_view = FilterView(frame:CGRectMake(frame.width / 3.0, 4, frame.width / 3.0, frame.height - 5))
        top_view = FilterView(frame:CGRectMake(frame.width / 3.0 * 2.0, 4, frame.width / 3.0, frame.height - 5))
        
        let new_button = UIButton(frame:CGRectMake(0, 0, frame.width / 3.0, frame.height - 1))
        let visit_button = UIButton(frame:CGRectMake(frame.width / 3.0, 0, frame.width / 3.0, frame.height - 1))
        let top_button = UIButton(frame:CGRectMake(frame.width / 3.0 * 2.0, 0, frame.width / 3.0, frame.height - 1))
        new_button.addTarget(self, action: #selector(FilterCustomView.onTappedNews(_:)), forControlEvents: UIControlEvents.TouchDown)
        visit_button.addTarget(self, action: #selector(FilterCustomView.onTappedView(_:)), forControlEvents: UIControlEvents.TouchDown)
        top_button.addTarget(self, action: #selector(FilterCustomView.onTappedTop(_:)), forControlEvents: UIControlEvents.TouchDown)
        
        new_view!.image_name = "home_ic_filter_news"
        new_view!.title = "NEW"
        
        visit_view!.image_name = "home_ic_tab_eye"
        visit_view!.title = "PIU VISTI"
        
        top_view!.image_name = "home_ic_filter_topblasted"
        top_view!.title = "TOP BLASTED"
        
        self.addSubview(new_view!)
        self.addSubview(visit_view!)
        self.addSubview(top_view!)
        self.addSubview(new_button)
        self.addSubview(visit_button)
        self.addSubview(top_button)
        new_view!.isSelected = true
        oldState = FilterMenu.Latest
        
    }
    
    func onTappedNews(sender:UIButton) -> Void {
        if oldState == FilterMenu.Latest {
            return
        }
        new_view!.isSelected = true
        visit_view!.isSelected = false
        top_view!.isSelected = false
        oldState = FilterMenu.Latest
        self.delegate?.filterChanged(.Latest)
    }
    
    func onTappedView(sender:UIButton) -> Void {
        if oldState == FilterMenu.Visit {
            return
        }
        new_view!.isSelected = false
        visit_view!.isSelected = true
        top_view!.isSelected = false
        
        oldState = FilterMenu.Visit
        self.delegate?.filterChanged(.Visit)
    }
    
    func onTappedTop(sender:UIButton) -> Void {
        if oldState == FilterMenu.Top {
            return
        }
        new_view!.isSelected = false
        visit_view!.isSelected = false
        top_view!.isSelected = true
        oldState = FilterMenu.Top
        self.delegate?.filterChanged(.Top)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
