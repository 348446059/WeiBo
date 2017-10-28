//
//  UserAccountTools.swift
//  DS11WB
//
//  Created by libo on 2017/10/23.
//  Copyright © 2017年 libo. All rights reserved.
//
///Users/user/Library/Developer/CoreSimulator/Devices/DE4B648D-8A44-4B3C-A72B-0FE3C9DC1BBA/data/Containers/Data/Application/36845037-DBA6-41E9-84CE-951203BF85D2/Documents/account.plist

import Foundation
class UserAccountTools {
    // 类设计为单利
    static let shareInstance:UserAccountTools = UserAccountTools()
    
    
    var account :UserAccount?
    
    var isLogin :Bool{
          if account == nil{
            return false
        }
        guard let expiresDate = account?.expires_date else{
            return false
        }
        
        return expiresDate.compare(Date()) == ComparisonResult.orderedDescending
    }
    
    
    var accountPath:String
    {
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        return  (accountPath as NSString).appending("/account.plist")
        
    }
    //MARK--重写
    init() {
       account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
    }
}

