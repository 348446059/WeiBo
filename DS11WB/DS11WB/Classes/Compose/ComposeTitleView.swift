//
//  ComposeTitleView.swift
//  DS11WB
//
//  Created by libo on 2017/10/28.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit
import SnapKit
class ComposeTitleView: UIView {
    //MARK:-懒加载
    private lazy var titleLabel:UILabel = UILabel()
    private lazy var screenNameLabel:UILabel = UILabel()
    override var intrinsicContentSize: CGSize{
        get{
            return UILayoutFittingExpandedSize
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ComposeTitleView{
    private func setupUI(){
        addSubview(titleLabel)
        addSubview(screenNameLabel)
        
        //2.设置frame
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        screenNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleLabel.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        screenNameLabel.font = UIFont.systemFont(ofSize: 14)
        screenNameLabel.textColor = UIColor.lightGray
        
        titleLabel.text = "发微博"
        screenNameLabel.text = UserAccountTools.shareInstance.account?.screen_name
    }
   
    
}
