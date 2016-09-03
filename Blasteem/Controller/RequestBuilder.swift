//
//  RequestBuilder.swift
//  PlugAccess
//
//  Created by k on 6/2/16.
//  Copyright © 2016 PlugAccess. All rights reserved.
//

import UIKit

class RequestBuilder: NSObject {
    
    private var parameters:NSMutableDictionary?
    internal var url:String?
    override init() {
        parameters = NSMutableDictionary()
    }
    
    //Methods For Basic Actions
    func addParameterWithKey(key:String,value:AnyObject) -> Void {
        parameters?.setObject(value, forKey: key)
    }
    
    func getParameters() -> NSDictionary {
        return parameters!
    }
    
    
    
}
