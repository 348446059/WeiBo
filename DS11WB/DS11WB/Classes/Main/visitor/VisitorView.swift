//
//  VisitorView.swift
//  DS11WB
//
//  Created by libo on 2017/10/21.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit

class VisitorView: UIView {
    //MARK:提供xib创建的类方法
    class func visitorView() -> VisitorView{
      return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.first as! VisitorView
    }
   
    //MARK: 控件的属性
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtnClick: UIButton!
    
    
    //MARK:--自定义方法
    func setupVisitorViewInfo(iconName:String,title:String)  {
        iconView.image = UIImage.init(named: iconName)
        tipLabel.text = title
        rotationView.isHidden = true
    }
    
    func addRotationAnim()  {
        //1.创建动画
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        //2 设置动画属性
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.repeatCount = MAXFLOAT
        rotation.duration = 5
        rotation.isRemovedOnCompletion = false
        
        //3.添加动画
        rotationView.layer.add(rotation, forKey: nil)
    }
}
