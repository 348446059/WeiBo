//
//  WelcomeViewController.swift
//  DS11WB
//
//  Created by libo on 2017/10/23.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit
import SDWebImage
class WelcomeViewController: UIViewController {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var iconViewBottomCons: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //??:如果??前面的可选类型有值，那么浅前面的可选类型进行解包并且复制
        //如果??前面的可选类型没值，就直接使用后面的值
        iconView.sd_setImage(with: URL(string: UserAccountTools.shareInstance.account?.avatar_large ?? ""), placeholderImage: #imageLiteral(resourceName: "avatar_default"))
        
        
        iconViewBottomCons.constant = UIScreen.main.bounds.height - 250
      
        // 执行动画  usingSpringWithDamping:阻力系数 0-1 initialSpringVelocity:初始化速度
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }

}
