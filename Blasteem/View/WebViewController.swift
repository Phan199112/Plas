//
//  WebViewController.swift
//  Blasteem
//
//  Created by k on 8/24/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class WebViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webview: UIWebView!
    var url:String?
    var post_title:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.webview.delegate = self
        self.webview.loadRequest(NSURLRequest(URL: NSURL(string: url!)!))
        self.webview.sizeToFit()
        
        self.titleLabel.text = post_title
        AppUtil.showLoadingHud()
    }
    @IBAction func onBack(sender: AnyObject) {
        AppUtil.disappearLoadingHud()
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        AppUtil.disappearLoadingHud()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func shouldAutorotate() -> Bool {
        return false
    }

}
