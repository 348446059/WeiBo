//
//  BaseViewController.swift
//  DS11WB
//
//  Created by libo on 2017/10/21.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
     lazy var visitorView:VisitorView  = VisitorView.visitorView()
    
    //定义变量
    var isLogin:Bool = UserAccountTools.shareInstance.isLogin
    
    //MARK:--系统会掉
    override func loadView() {
        //1 获取沙河路径
        var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        accountPath   =   (accountPath as NSString).appending("/account.plist")
        let account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
        if let account = account{
            //1.取出access_token
          if  let expiresDate = account.expires_date{
           isLogin =  expiresDate.compare(Date()) == ComparisonResult.orderedDescending
            }
        }
        
        isLogin ? super.loadView():setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigatorItems()
    }

}

extension BaseViewController{
    private func setupVisitorView(){
        view = visitorView
        
        //监听访客视图的注册和登录
        visitorView.registerBtn.addTarget(self, action: #selector(registerBtnClick), for: .touchUpInside)
        visitorView.loginBtnClick.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
    }
    //设置导航栏左右的item
    private func setupNavigatorItems(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(loginBtnClick))
    }
}

//MARK:--事件监听
extension BaseViewController{
   @objc private func registerBtnClick(){
        print("========")
    }
    @objc private func loginBtnClick(){
        //创建授权控制器
        let oauthVC = OAuthViewController()
        //包装导航控制器
        let oauthNav = UINavigationController(rootViewController: oauthVC)
        //弹出控制器
        present(oauthNav, animated: true, completion: nil)
        
    }
}
