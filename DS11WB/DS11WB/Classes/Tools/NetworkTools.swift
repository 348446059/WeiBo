//
//  NetworkTools.swift
//  DS11WB
//
//  Created by libo on 2017/10/22.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit
import AFNetworking
//定义枚举类型
enum RequestType:String {
    case GET = "GET"
    case POST = "POST"
}

class NetworkTools: AFHTTPSessionManager {
    //let是线程安全 单利写法
    static let shareInstance : NetworkTools = {
        let tools = NetworkTools()
 tools.responseSerializer.acceptableContentTypes?.insert("text/html")
 tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
    }()
}

//MARK:--封装请求
extension NetworkTools{
    func request(methodType:RequestType,url:String,params:[String : AnyObject],finished:@escaping (_ result:AnyObject?,_ error:NSError?)->())  {
        
       
        
        if methodType == .GET {
            get(url, parameters: params, progress: nil, success: {(task,result) in
                
                finished(result as AnyObject,nil)
            }, failure: {(task, error) in
                finished(nil,error as NSError)
            })

        }else{
            post(url, parameters: params, progress: nil, success: { (task, result) in
                 finished(result as AnyObject,nil)
            }, failure: { (task, error) in
                finished(nil,error as NSError)
            })
            
        }
        
    }
}
//请求access_token
extension NetworkTools{
    func loadAccessToken(code:String,finished:@escaping (_ result:[String:AnyObject]?,_ error:Error?)->())  {
        //1.封装请求参数
        let urlString = "https://api.weibo.com/oauth2/access_token"
        //2. 获取请求的参数
        let params = ["client_id":app_key,"client_secret":app_screte,"grant_type":"authorization_code","code":code,"redirect_uri":redirect_url] as [String:AnyObject]
        
        request(methodType: .POST, url: urlString, params: params) { (result, error) in
            finished(result! as? [String : AnyObject],error)
        }
    }
}
//请求用户信息
extension NetworkTools{
    func loadUserInfo(access_token:String,uid:String,finished:@escaping ([String:AnyObject]?,NSError?)->())  {
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        let params = ["access_token":access_token,"uid":uid] as [String :AnyObject]
        
        request(methodType: .GET, url: urlString, params: params) { (result, error) in
            finished(result as? [String : AnyObject],error)
        }
        
        
    }
}

//请求首页数据
extension NetworkTools{
    func loadStatuses(since_id:Int,max_id:Int, finished:@escaping ([[String:AnyObject]]?,NSError?)->())  {
        //1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        //2.请求参数
        
        
        guard let access_token = UserAccountTools.shareInstance.account?.access_token else {
            return
        }
       
        
        let params = ["access_token":access_token,"since_id":"\(since_id)","max_id":"\(max_id)"] as [String : AnyObject]
        
        //3.发送网络请求
        request(methodType: .GET, url: urlString, params: params ) { (result, error) in
           
            guard let resultDic = result as? [String:AnyObject] else{
                
                finished(nil,error)
                return
            }
            //将数组回调给外界
            finished(resultDic["statuses"] as? [[String:AnyObject]],error)
        }
    }
}

//发送微博
extension NetworkTools{
    func sendStatus(statusText:String ,isSuccess:@escaping (Bool)->()) {
        let urlString = "https://api.weibo.com/2/statuses/share.json"
        
        let access_token = UserAccountTools.shareInstance.account?.access_token
        let str = statusText + redirect_url
        
        //redirect_url.
        let params = ["access_token":access_token!,"status":str] as [String:AnyObject]
        
        request(methodType: .POST, url: urlString, params: params) { (result, error) in
            if result != nil{
                isSuccess(true)
            }else{
                print(String(describing: error))
                isSuccess(false)
            }
        }
        
        
    }
}

extension NetworkTools{
    func sendStatus(statusText:String,image:UIImage,isSuccess:@escaping(Bool)->()) {
        let urlString = "https://api.weibo.com/2/statuses/share.json"
        
        let access_token = UserAccountTools.shareInstance.account?.access_token
        let str = statusText + redirect_url
        
        //redirect_url.
        let params = ["access_token":access_token!,"status":str] as [String:AnyObject]
        
        post(urlString, parameters: params, constructingBodyWith: { (formData) in
            if  let imageData = UIImageJPEGRepresentation(image, 0.2) {
                formData.appendPart(withForm: imageData, name: "pic")
            }
            
        }, progress: nil, success: { (_, _) in
            isSuccess(true)
        }) { (_, error) in
            print(error)
        }
        
    }
}















