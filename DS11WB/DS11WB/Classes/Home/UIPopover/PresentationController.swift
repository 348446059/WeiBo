//
//  PresentationController.swift
//  DS11WB
//
//  Created by libo on 2017/10/21.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    private lazy var coverView:UIView = UIView()
    lazy var coverFrame:CGRect = CGRect.zero
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        //1.设置弹出view的尺寸
        presentedView?.frame = coverFrame
        
        //2.添加蒙版
        setupCoverView()
    }
    
}

extension PresentationController{
    private func setupCoverView(){
        //1.添加蒙版
        containerView?.insertSubview(coverView, at: 0)
        //2.设置蒙版的属性
        coverView.backgroundColor = UIColor.init(white: 0.8, alpha: 0.2)
        coverView.frame = containerView!.bounds
        
        //3.添加手势
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(coverViewAction))
        coverView.addGestureRecognizer(tapGes)
    }
}

extension PresentationController{
    @objc private func coverViewAction(){
       presentedViewController.dismiss(animated: true, completion: nil)
    }
}






