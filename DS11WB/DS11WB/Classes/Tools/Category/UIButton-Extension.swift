//
//  UIButton-Extension.swift
//  DS11WB
//
//  Created by libo on 2017/10/21.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit
extension UIButton {
    // 在swift中类方法
    /*
    class func createButton(image:UIImage,bgImage:UIImage)->UIButton{
        let btn = UIButton()
        print("name:\(String(describing: image.accessibilityIdentifier))")
     
        return btn
    }
     */
    //便利构造函数  对系统对象构造函数的扩充
    //1.遍历构造函数都是写在extension
    //2 需要添加convenience
    //3.在便利构造函数中需要添加self.init()
    convenience init(image:UIImage,bgImage:UIImage) {
        self.init()
        setImage(image, for: .normal)
        setImage(UIImage.init(named: image.accessibilityIdentifier!+"_highlighted"), for: .highlighted)
        
        setBackgroundImage(bgImage, for: .normal)
        setBackgroundImage(UIImage.init(named: bgImage.accessibilityIdentifier!+"_highlighted"), for: .highlighted)
        
        sizeToFit()
        
    }
    
}
