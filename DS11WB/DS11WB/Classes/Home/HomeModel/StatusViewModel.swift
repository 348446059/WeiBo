//
//  StatysViewModel.swift
//  DS11WB
//
//  Created by libo on 2017/10/26.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit

class StatusViewModel : NSObject {
    //MARK:--定义属性
    var status:Statuses?
    
    //MARK:-对数据处理
    var sourceText:String?
    var createAtText :String?
    
    //MARK:对应数据处理
    var verifiedImage : UIImage?
    var vipImage :UIImage?
    var profileUrl :URL?  //用户头像地址
    var picURLs :[URL] = [URL]() //处理微博配图的数据
    
    //MARK:--自定义视图模型
    init(status:Statuses) {
        self.status = status
        //处理来源
        if let source = status.source,status.source != ""{
            //获取起失位置和截取长度
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            
            sourceText = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
        
        //时间处理
        if let creatAt = status.created_at {
            createAtText = NSDate.createDateString(createAtStr: creatAt)
        }
        
        //处理认证
        let verifiedType = status.user?.verified_type ?? -1
        switch verifiedType {
        case 0:
            verifiedImage = #imageLiteral(resourceName: "avatar_vip")
        case 2,3,5:
            verifiedImage = #imageLiteral(resourceName: "avatar_enterprise_vip")
        case 220:
            verifiedImage = #imageLiteral(resourceName: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        //处理会员图标
        let mbrank = status.user?.mbrank ?? 0
        
        if (mbrank > 0 && mbrank <= 6) {
            vipImage = UIImage.init(named: "common_icon_membership_level\(mbrank)")
        }
        
        // 5.用户头像处理
        let profileUrlString = status.user?.profile_image_url ?? ""
        profileUrl = URL(string: profileUrlString)
       
        
        //6.处理配图数据
        if let picURLDicts = status.pic_urls {
            for picURLDict in picURLDicts {
                guard  let picURLString = picURLDict["thumbnail_pic"] else{
                    return
                }
                picURLs.append(URL(string: picURLString)!)
            }
        }
    }
    
}
