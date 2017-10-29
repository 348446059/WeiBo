//
//  HomeViewController.swift
//  DS11WB
//
//  Created by libo on 2017/10/15.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh
class HomeViewController: BaseViewController {
    
    //MARK:--懒加载
    //1.闭包中使用当前对象的属性self 2.函数中出现歧义
    private lazy var popoverAnimator:PopverAnimator = PopverAnimator {[weak self] (presented) in
        self?.titleBtn.isSelected = presented
    }
    //提示view
    private lazy var tipLabel:UILabel = UILabel()
    
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
        
      
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
       //4 .布局header
        setupHeaderView()
        setupFooterView()
        
        //5.设置提示label
        setupTipView()
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
    
    private func setupHeaderView(){
        //创建headerView
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewDate))
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("加载中", for: .refreshing)
        
        //3.设置tableview的header
        tableView.mj_header = header
        
        //4.进入刷新状态
       // tableView.mj_header.beginRefreshing()
    }
    
    
    private func setupFooterView(){
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreDate))
    }
    
    private func setupTipView(){
        //1.将tipLabel添加
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        
        //2.设置frame
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 32)
        
        //3.设置属性
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.font  = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
        
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
    //加载最新的数据
    @objc private func loadNewDate(){
        loadStatuses(true)
    }
    @objc private func loadMoreDate(){
        loadStatuses(false)
    }
    
    private func loadStatuses(_ isNewDate:Bool){
        //1.获取since_id
        var since_id = 0
        var max_id = 0
        
        if isNewDate {
            since_id = viewModels.first?.status?.mid ?? 0
        }else{
            max_id = viewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
        NetworkTools.shareInstance.loadStatuses(since_id: since_id, max_id: max_id) { (result, error) in
            //1.数据错误校验
            if error != nil{
                return
            }
            
            //2.获取可选类型的数据
            guard let resultArray = result else{
                return
            }
            //3.便利数据
            var tempViewModel = [StatusViewModel]()
            for statusDic in resultArray{
                let status = Statuses(dict: statusDic)
                let viewModel = StatusViewModel(status: status  )
                tempViewModel.append(viewModel)
            }
            //4.将最新数据放入数组中
            if isNewDate{
                 self.viewModels = tempViewModel + self.viewModels
            }else{
                self.viewModels += tempViewModel
            }
           
            
            //4.缓存图片
            self.cacheImages(viewModels: tempViewModel)
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
             self.tableView.mj_header.endRefreshing()
             self.tableView.mj_footer.endRefreshing()
            
            self.showTipLabel(count: viewModels.count)
            
        }
        
    }
    
    private func showTipLabel(count:Int){
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有新数据":"\(count) 条新微博"
        
        UIView.animate(withDuration: 1.0, animations: {
            self.tipLabel.frame.origin.y = 44
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 1.5, options: [], animations: {
                self.tipLabel.frame.origin.y = 10
            }, completion: { (_) in
                self.tipLabel.isHidden = true
            })
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


