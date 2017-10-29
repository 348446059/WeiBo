//
//  User.swift
//  DS11WB
//
//  Created by libo on 2017/10/26.
//  Copyright © 2017年 libo. All rights reserved.
//

import Foundation
import UIKit
class User: NSObject {
    //属性
    @objc   var profile_image_url:String?
    @objc   var screen_name :String?
    @objc   var verified_type :Int = -1
    @objc   var mbrank :Int = 0
   
    
    init(dict:[String:AnyObject]){
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
