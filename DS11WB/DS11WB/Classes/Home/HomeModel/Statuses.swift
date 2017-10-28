//
//  Status.swift
//  DS11WB
//
//  Created by libo on 2017/10/25.
//  Copyright © 2017年 libo. All rights reserved.
//

import Foundation
class Statuses: NSObject {
    //MARK:--属性
    @objc var created_at:String? //创建时间
    @objc var source:String? //来源
    @objc var text :String? //正文
    @objc var mid:Int = 0 //微博ID
    var user : User?      //微博用户
    @objc var pic_urls : [[String:String]]? //微博的配图
    var retweeted_status:Statuses? //转发的微博
    
    //MARK:--自定义构造函数
   init(dict:[String:AnyObject]){
        super.init()
       setValuesForKeys(dict)
    //1.将用户字典转陈用户模型对象
    if let userDict = dict["user"] as? [String:AnyObject]{
        user = User(dict: userDict)
    }
    //2.将转发微博字典封装成转发微博对象
    if let retweetedStatus = dict["retweeted_status"] as? [String:AnyObject] {
        retweeted_status = Statuses(dict: retweetedStatus)
    }
    
  }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
