//
//  TitleBtn.swift
//  DS11WB
//
//  Created by libo on 2017/10/21.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit

class TitleBtn: UIButton {
    //重写init函数
    override init(frame:CGRect) {
        super.init(frame: frame)
        setImage(#imageLiteral(resourceName: "navigationbar_arrow_up"), for: .normal)
        setImage(#imageLiteral(resourceName: "navigationbar_arrow_down"), for: .selected)
        setTitle("上善若水", for: .normal)
        setTitleColor(UIColor.black, for: .normal)
        sizeToFit()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel!.frame.origin.x = 0
        imageView?.frame.origin.x = (titleLabel?.bounds.width)! + 8
   
    }
    //swift规定：重写了init方法必须重写init?(coder aDecoder:)方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
