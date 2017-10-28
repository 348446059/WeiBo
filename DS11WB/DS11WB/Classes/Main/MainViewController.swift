//
//  MainViewController.swift
//  DS11WB
//
//  Created by libo on 2017/10/15.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    //MARK: 懒加载属性
    private var composeBtn :UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = #imageLiteral(resourceName: "tabbar_compose_icon_add")
        let bgImage = #imageLiteral(resourceName: "tabbar_compose_button")
        
          image.accessibilityIdentifier = "tabbar_compose_icon_add"
         bgImage.accessibilityIdentifier = "tabbar_compose_buttom"
        composeBtn  = UIButton(image: image, bgImage: bgImage)
       tabBar.addSubview(composeBtn!)
        setComposeBtn()
      
    }
    
    func setComposeBtn()  {
        
        composeBtn!.sizeToFit()
        composeBtn!.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        // Selector两种写法:
        composeBtn?.addTarget(self, action: #selector(MainViewController.composeBtnClick), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:--事件监听
extension MainViewController{
    //@SEL -->类中查找方法列表-->根据@SEL找到imp函数-->执行函数
    //如果在private中加入@objc 说明该方法依然被加入到方法列表中
     @objc private func composeBtnClick(){
      
    }
    
}
