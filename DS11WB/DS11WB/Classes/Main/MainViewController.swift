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
 private lazy var imageNames = ["tabbar_home","tabbar_message_center","","tabbar_discover","tabbar_profile"]
    
    
    
    
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
    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
