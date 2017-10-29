//
//  ComposeTextView.swift
//  DS11WB
//
//  Created by libo on 2017/10/28.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit
import SnapKit
class ComposeTextView: UITextView {
     lazy var placeHoderLabel:UILabel = UILabel()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
}
//MARK:--设置UI界面
extension ComposeTextView{
    private func setupUI(){
        addSubview(placeHoderLabel)
        
        placeHoderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        
        placeHoderLabel.textColor = UIColor.lightGray
        placeHoderLabel.font = font
        
        placeHoderLabel.text = "分享新鲜事"
        
        textContainerInset = UIEdgeInsets(top: 6, left: 7, bottom: 0, right: 7)
    }
}
