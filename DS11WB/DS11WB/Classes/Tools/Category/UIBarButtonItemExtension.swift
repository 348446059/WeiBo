//
//  UIBarButtonItemExtension.swift
//  DS11WB
//
//  Created by libo on 2017/10/21.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    convenience init(image:UIImage) {
        self.init()
        let btn = UIButton()
        btn.setImage(image, for: .normal)
        btn.setImage(UIImage.init(named: image.accessibilityIdentifier!+"_highlighted"), for: .highlighted)
        btn.sizeToFit()
        
        self.customView = btn
    }
}
