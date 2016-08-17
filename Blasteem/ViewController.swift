//
//  ViewController.swift
//  Blasteem
//
//  Created by k on 8/17/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit
import Segmentio
class ViewController: UIViewController {

    @IBOutlet weak var segmentioView: Segmentio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Segment Setting Related
    private func segmentioOptions() -> SegmentioOptions {
        let imageContentMode = UIViewContentMode.ScaleAspectFit
        return SegmentioOptions(
            backgroundColor: UIColor.clearColor(),
            maxVisibleItems: 5,
            scrollEnabled: false,
            indicatorOptions: segmentioIndicatorOptions(),
            horizontalSeparatorOptions: segmentioHorizontalSeparatorOptions(),
            verticalSeparatorOptions: segmentioVerticalSeparatorOptions(),
            imageContentMode: imageContentMode,
            labelTextAlignment: .Center,
            segmentStates: segmentioStates()
        )
    }
    
    private func segmentioStates() -> SegmentioStates {
        let font = UIFont.systemFontOfSize(13);
        return SegmentioStates(
            defaultState: segmentioState(
                backgroundColor: UIColor.clearColor(),
                titleFont: font,
                titleTextColor: UIColor.whiteColor()
            ),
            selectedState: segmentioState(
                backgroundColor: UIColor.clearColor(),
                titleFont: font,
                titleTextColor: UIColor.whiteColor()
            ),
            highlightedState: segmentioState(
                backgroundColor: UIColor.clearColor(),
                titleFont: font,
                titleTextColor: UIColor.whiteColor()
            )
        )
    }
    
    private func segmentioState(backgroundColor backgroundColor: UIColor, titleFont: UIFont, titleTextColor: UIColor) -> SegmentioState {
        return SegmentioState(backgroundColor: backgroundColor, titleFont: titleFont, titleTextColor: titleTextColor)
    }
    
    private func segmentioIndicatorOptions() -> SegmentioIndicatorOptions {
        return SegmentioIndicatorOptions(
            type: .Bottom,
            ratio: 1,
            height: 5,
            color: UIColor.whiteColor()
        )
    }
    
    private func segmentioHorizontalSeparatorOptions() -> SegmentioHorizontalSeparatorOptions {
        return SegmentioHorizontalSeparatorOptions(
            type: .TopAndBottom,
            height: 0,
            color: UIColor.whiteColor()
        )
    }
    
    private func segmentioVerticalSeparatorOptions() -> SegmentioVerticalSeparatorOptions {
        return SegmentioVerticalSeparatorOptions(
            ratio: 0,
            color: UIColor.whiteColor()
        )
    }

}

