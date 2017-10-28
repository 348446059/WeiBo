//
//  OAuthViewController.swift
//  DS11WB
//
//  Created by libo on 2017/10/22.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit
import SVProgressHUD
class OAuthViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        loadPage()
       
    }
}

extension OAuthViewController{
    private func setNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(fillItemClick))
        
        title = "登录页面"
    }
    
    private func loadPage(){
        //获取登录页面的url
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_url)"
        // 创建对应的NSUrl
        guard let url = URL(string: urlString) else{
            return
        }
        let request = URLRequest(url: url)
        webView.loadRequest(request)
        
        
    }
    
}

extension OAuthViewController{
    @objc private func closeBtnClick(){

        dismiss(animated: true, completion: nil)
    }
    @objc private func fillItemClick(){
        let jsCode = "document.getElementById('userId').value='15353616101';document.getElementById('passwd').value='0913wayt';"
        
        webView.stringByEvaluatingJavaScript(from: jsCode)
        
    }
}
//MARK:--webViewDelegate
extension OAuthViewController:UIWebViewDelegate{
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    //当准备加载某一个页面时加载此方法
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //1.获取url
        guard let url = request.url else {
            return true
        }
        //2.获取url字符串
        let urlString = url.absoluteString
        
      
        //3.判断该字符串是否包含code字符串
        
        guard urlString.contains("code=") else {
            return true
        }
        let code = urlString.components(separatedBy: "code=").last!
        print("\(code)")
        
        //4.请求access_token
        loadAccessToken(code: code)
        return false
    }
}
//MARK:-请求数据
extension OAuthViewController{
    
    //请求token
    private func loadAccessToken(code:String){
        NetworkTools.shareInstance.loadAccessToken(code: code) { (info, error) in
            //1.错误校验
            if error != nil{
                print("\(error)")
                return
            }
            // 2.拿到结果
            guard let accountDic = info else{
                return
            }
            // 3.将字典转模型对象
            let account = UserAccount(dict: accountDic)
            
            //4.请求用户信息
            self.loadUserInfo(account: account)
            UserAccountTools.shareInstance.account = account
            //5.显示欢迎界面
            self.dismiss(animated: false, completion: {
                UIApplication.shared.keyWindow?.rootViewController = WelcomeViewController()
            })
         }
    }
    
    ///请求用户信息
    private func loadUserInfo(account:UserAccount){
        //1.获取access_token
        guard  let access_token = account.access_token else{
            return
        }
        
        //2.获取uid
        guard let uid = account.uid else {
            return
        }
        //3.发送网络请求
        NetworkTools.shareInstance.loadUserInfo(access_token: access_token, uid: uid) { (result, error) in
            if error != nil{
                print("\(error)")
                return
            }
            
            guard let userInfo = result else{
                return
            }
            account.screen_name = userInfo["screen_name"] as? String
            account.avatar_large = userInfo["avatar_large"] as? String
            
            //4.保存对象
            var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            
            accountPath   =   (accountPath as NSString).appending("/account.plist")
            NSKeyedArchiver.archiveRootObject(account, toFile: accountPath)
            print("\(accountPath)")
        }
    }
    
}
