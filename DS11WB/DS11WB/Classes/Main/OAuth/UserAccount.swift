//
//  UserAccount.swift
//  DS11WB
//
//  Created by libo on 2017/10/22.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit

class UserAccount: NSObject,NSCoding{
    //归档方法
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
    
    //解档方法
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? NSDate
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
    }
    
  //MARK：--属性
   @objc var access_token : String?
    @objc var expires_in : Double = 0.0 {
        didSet{
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
   @objc var uid :String?
    
    //过期日期
    var expires_date:NSDate?
    //昵称
    var screen_name: String?
    //头像
    var avatar_large :String?
    
    
    //MARK--自定义构造函数
    init(dict:[String : AnyObject]) {
        super.init()

        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("\(key)不存在")
    }
    
    override var description: String{
        return dictionaryWithValues(forKeys: ["access_token","expires_in","uid","avatar_large","screen_name"]).description
    }
    
}
