//
//  ComManager.swift
//  PlugAccess
//
//  Created by k on 5/31/16.
//  Copyright © 2016 PlugAccess. All rights reserved.
//

import UIKit
import Alamofire

class ComManager: NSObject {
    typealias APIHandler = (responseBuilder:ResponseBuilder) -> Void
    typealias VideoListHandler = (videolist:[VideoModel]) -> Void
    typealias ErrorHandler = (error:NSError) ->Void
    
    typealias TokenHandler = (isSuccess:Bool,error:NSError?) -> Void
    let url:String = ApiUrl.BASEURL
    let oauth_url:String = "oauth/token"
    var access_token:String?
    
    //Post Request
    func getVideoList(requestBuilder:RequestBuilder,successHandler:APIHandler,errorHandler:ErrorHandler) -> Void {
        self.hasValidToken{ (isSuccess, error) in
            if isSuccess{
                
                do {
                    let jsonData = try NSJSONSerialization.dataWithJSONObject(requestBuilder.getParameters(), options: NSJSONWritingOptions.PrettyPrinted)
                    // here "jsonData" is the dictionary encoded in JSON data
                    let request = NSMutableURLRequest(URL:NSURL(string: ApiUrl.BASEURL + requestBuilder.url! + "?access_token=" + self.access_token!)!)
                    
                    request.HTTPMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.HTTPBody =  jsonData
                    
                    Alamofire.request(request)
                        .responseJSON { response in
                            // do whatever you want here
                            switch response.result {
                            case .Failure(let error):
                                print(error)
                                
                                // if web service reports error, sometimes the body of the response
                                // includes description of the nature of the problem, e.g.
                                if let data = response.data, let responseString = String(data: data, encoding: NSUTF8StringEncoding) {
                                    print(responseString)
                                }
                                errorHandler(error: error)
                                
                            case .Success(let JSON):
                                let dictionary:NSDictionary = JSON as! NSDictionary
                                let responseBuilder:ResponseBuilder = ResponseBuilder(response:dictionary)
                                successHandler(responseBuilder: responseBuilder)
                                print(dictionary)
                            }
                    }
                } catch let error as NSError {
                    print(error)
                }

                
            }else{
                errorHandler(error: error!)
            }
        }
    }
    
    func postRequestToServer(requestBuilder:RequestBuilder,successHandler:APIHandler,errorHandler:ErrorHandler) -> Void {
        
        self.hasValidToken{ (isSuccess, error) in
            if isSuccess{
                requestBuilder.addParameterWithKey("access_token", value: self.access_token!)
                self.executeHttpPostRequest(ApiUrl.BASEURL + requestBuilder.url!, params:requestBuilder.getParameters(), SuccessHandler: { (result) in
                    let responseBuilder:ResponseBuilder = ResponseBuilder(response:result)
                    successHandler(responseBuilder: responseBuilder)
                }) { (error) in
                    errorHandler(error: error)
                }
            }else{
                errorHandler(error: error!)
            }
        }
        
    }
    //Get Request
    func getRequestToServer(requestBuilder:RequestBuilder,successHandler:APIHandler,errorHandler:ErrorHandler) -> Void {
        
        self.hasValidToken{ (isSuccess, error) in
            if isSuccess{
                requestBuilder.addParameterWithKey("access_token", value: self.access_token!)
                self.executeHttpGetRequest(ApiUrl.BASEURL + requestBuilder.url!, params:requestBuilder.getParameters(), SuccessHandler: { (result) in
                    let responseBuilder:ResponseBuilder = ResponseBuilder(response:result)
                    successHandler(responseBuilder: responseBuilder)
                }) { (error) in
                    errorHandler(error: error)
                }
            }else{
                errorHandler(error: error!)
            }
        }
        
    }
    //Oauth Manager
    func hasValidToken(tokenHandler:TokenHandler) -> Void {
        var token:AppTokenModel?
        if let decoded:NSData = USER_DEFAULTS.objectForKey(APP_TOKEN) as? NSData {
            token = NSKeyedUnarchiver.unarchiveObjectWithData(decoded) as? AppTokenModel
        }
        if token != nil {
            if token?.expires_in > NSDate().timeIntervalSince1970 {
                
                if let decoded:NSData = USER_DEFAULTS.objectForKey(APP_TOKEN) as? NSData {
                    let token = NSKeyedUnarchiver.unarchiveObjectWithData(decoded) as? AppTokenModel
                    self.access_token = token?.access_token
                }
                tokenHandler(isSuccess: true, error: nil)
            }else{
                
                let param = NSDictionary(objects: ["refresh_token",(token?.refresh_token)!,AppCredential.CLIENT_ID,AppCredential.CLIENT_SECRET], forKeys: ["grant_type","refresh_token","client_id","client_secret"])
                self.executeHttpPostRequest(url + oauth_url, params: param, SuccessHandler: { (result) in
                    
                     let code = result.objectForKey("code") as? String
                    
                        if code == "invalid_grant"
                        {
                            let param = NSDictionary(objects: ["password",AppCredential.CLIENT_ID,AppCredential.CLIENT_SECRET,AppCredential.API_UNAME,AppCredential.API_PWD], forKeys: ["grant_type","client_id","client_secret","username","password"])
                            self.executeHttpPostRequest(self.url + self.oauth_url, params: param, SuccessHandler: { (result) in
                                let newToken = AppTokenModel(access_token: result["access_token"] as? String, expires_in: (result["expires_in"] as? Double)! + NSDate().timeIntervalSince1970, refresh_token: result["refresh_token"] as? String, scope: result["scope"] as? String)
                                USER_DEFAULTS.setObject(NSKeyedArchiver.archivedDataWithRootObject(newToken), forKey: APP_TOKEN)
                                self.access_token = newToken.access_token
                                tokenHandler(isSuccess: true, error: nil)
                                }, Errorhandler: { (error) in
                                    tokenHandler(isSuccess: true , error: error)
                            })
                        }else{
                            let newToken = AppTokenModel(access_token: result["access_token"] as? String, expires_in: (result["expires_in"] as? Double)! + NSDate().timeIntervalSince1970, refresh_token: result["refresh_token"] as? String, scope: result["scope"] as? String)
                            USER_DEFAULTS.setObject(NSKeyedArchiver.archivedDataWithRootObject(newToken), forKey: APP_TOKEN)
                            
                            self.access_token = newToken.access_token
                            tokenHandler(isSuccess: true, error: nil)
                            
                        }
                    
                    }, Errorhandler: { (error) in
                    tokenHandler(isSuccess: true , error: error)
                })
            }
        }else{
            let param = NSDictionary(objects: ["password",AppCredential.CLIENT_ID,AppCredential.CLIENT_SECRET,AppCredential.API_UNAME,AppCredential.API_PWD], forKeys: ["grant_type","client_id","client_secret","username","password"])
            self.executeHttpPostRequest(url + oauth_url, params: param, SuccessHandler: { (result) in
                let newToken = AppTokenModel(access_token: result["access_token"] as? String, expires_in: (result["expires_in"] as? Double)! + NSDate().timeIntervalSince1970, refresh_token: result["refresh_token"] as? String, scope: result["scope"] as? String)
                USER_DEFAULTS.setObject(NSKeyedArchiver.archivedDataWithRootObject(newToken), forKey: APP_TOKEN)
                self.access_token = newToken.access_token
                tokenHandler(isSuccess: true, error: nil)
                }, Errorhandler: { (error) in
                    tokenHandler(isSuccess: true , error: error)
            })
        }
    }
    
    func executeHttpPostRequest(url:String,params:NSDictionary,SuccessHandler:(result: NSDictionary) ->Void,Errorhandler:(error:NSError) -> Void){
        
        Alamofire.request(.POST, url, parameters: params as? [String : AnyObject]).responseJSON {response in
            switch response.result{
            case .Success(let JSON):
                let dictionary:NSDictionary = JSON as! NSDictionary
                SuccessHandler(result: dictionary)
                break
            case .Failure(let error):
                Errorhandler(error: error)
                break
                
            }
        }
    }
    
    func executeHttpGetRequest(url:String,params:NSDictionary,SuccessHandler:(result: NSDictionary) ->Void,Errorhandler:(error:NSError) -> Void){
        
        Alamofire.request(.GET, url, parameters: params as? [String : AnyObject]).responseJSON {response in
            switch response.result{
            case .Success(let JSON):
                let dictionary:NSDictionary = JSON as! NSDictionary
                SuccessHandler(result: dictionary)
                break
            case .Failure(let error):
                Errorhandler(error: error)
                break
                
            }
        }
    }

}
