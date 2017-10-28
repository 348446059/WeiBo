//
//  HomeViewController.swift
//  DS11WB
//
//  Created by libo on 2017/10/15.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit
import SDWebImage
class HomeViewController: BaseViewController {
    
    //MARK:--懒加载
    //1.闭包中使用当前对象的属性self 2.函数中出现歧义
    private lazy var popoverAnimator:PopverAnimator = PopverAnimator {[weak self] (presented) in
        self?.titleBtn.isSelected = presented
    }
    private lazy var viewModels:[StatusViewModel] = [StatusViewModel]()
    //MARK:--懒加载
    private lazy var titleBtn: TitleBtn = TitleBtn()
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.没有登陆时设置的内容
        visitorView.addRotationAnim()
      //  https://api.weibo.com/2/statuses/home_timeline.json
        //2.设置导航栏的内容
        if !isLogin {
            return
        }
        
        setNavigationBar()
        
        //3.加载首页数据
        loadStatuses()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
    }
}
//MARK:- 设置UI界面
extension HomeViewController{
    //1.设置Item
    private func setNavigationBar() {
       
        let leftImage = #imageLiteral(resourceName: "navigationbar_friendattention")
        leftImage.accessibilityIdentifier = "navigationbar_friendattention"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image:leftImage)
        //右侧按钮
        let rightImage = #imageLiteral(resourceName: "navigationbar_pop")
        rightImage.accessibilityIdentifier = "navigationbar_pop"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage)
        
        //titleView
        navigationItem.titleView = titleBtn
        titleBtn.addTarget(self, action: #selector(titleBtnClick(titleBtn:)), for: .touchUpInside)
    }
}

//MARK:--事件监听
extension HomeViewController{
    @objc private func titleBtnClick(titleBtn:TitleBtn){
       
        //1.创建弹出的控制器
        let popoverVC = PopoverViewController()
        
        popoverVC.modalPresentationStyle = .custom
        
        //2.设置转场动画
        popoverVC.transitioningDelegate = popoverAnimator
        popoverAnimator.coverFrame = CGRect(x: 100, y: 55, width: 180, height: 250)
        //3.弹出控制器
        present(popoverVC, animated: true, completion: nil)
        
    }
}

//MARK：--请求数据
extension HomeViewController{
    private func loadStatuses(){
        NetworkTools.shareInstance.loadStatuses { (result, error) in
            //1.数据错误校验
            if error != nil{
                return
            }
            
            //2.获取可选类型的数据
            guard let resultArray = result else{
                return
            }
            //3.便利数据
            for statusDic in resultArray{
                let status = Statuses(dict: statusDic)
                let viewModel = StatusViewModel(status: status  )
                self.viewModels.append(viewModel)
            }
            //4.缓存图片
            self.cacheImages(viewModels: self.viewModels)
          //  self.tableView.reloadData()
        }
        
    }
    
    private func cacheImages(viewModels:[StatusViewModel]){
        let group = DispatchGroup.init()
        
       
        
        //1.缓存图片
        for viewModel in viewModels {
            for picURL in viewModel.picURLs {
                group.enter()
                SDWebImageManager.shared().loadImage(with: picURL, options: [], progress: nil, completed: { (_, _, _, _, _, _) in
                    group.leave()
                })
                
            }
        }
        
        //2.刷新表格
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
        
    }
}

//MARK:--tableview
extension HomeViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1.创建cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellID") as! HomeViewCell
        //2.设置数据
        let viewModel = viewModels[indexPath.row]
        
        cell.viewModel = viewModel
        
        return cell
    }
    
   
}


