//
//  ComposeViewController.swift
//  DS11WB
//
//  Created by libo on 2017/10/28.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit
import SVProgressHUD
class ComposeViewController: UIViewController {
    
    private lazy var titleView:ComposeTitleView = ComposeTitleView()
    private lazy var images:[UIImage] = [UIImage]()
    
    private lazy var emoticonVC:EmoticonController = EmoticonController {[weak self] (emoticon) in
        self?.textView.insertEmoticon(emoticon: emoticon)
        self?.textViewDidChange(self!.textView)
    }
    @IBOutlet weak var textView: ComposeTextView!
    
    @IBOutlet weak var toolbarBottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var picPickerViewBottomCons: NSLayoutConstraint!
    
    
    @IBOutlet weak var picPickerView: PicPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置导航
        setNavigationBar()
        
        //监听通知
        setupNotifications()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
 
    @IBAction func picPicker() {
        //退出键盘
        textView.resignFirstResponder()
        //执行动画
        picPickerViewBottomCons.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    
    @IBAction func emoticonBtnClick(_ sender: Any) {
        textView.resignFirstResponder()
        textView.inputView = textView.inputView != nil ? nil : emoticonVC.view
        
        textView.becomeFirstResponder()
    }
}

extension ComposeViewController{
    private func setNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeBtnClick))
        
         navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(sendBtnClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        //navigationController?.navigationBar.ta
       // titleView.intrinsicContentSize = CGSize(width: 200.0, height: 40.0)
        navigationItem.titleView = titleView
        
//        titleView.backgroundColor = UIColor.blue
//         titleView.layer.borderWidth = 1.0
//        titleView.layer.borderColor = UIColor.red.cgColor
       
    }
    
    private func setupNotifications(){
        //键盘
          NotificationCenter.default.addObserver(self, selector: #selector(KeyboardFrameWillShow), name: .UIKeyboardWillChangeFrame, object: nil)
        //添加按钮的点击
        NotificationCenter.default.addObserver(self, selector: #selector(addPhotoClick), name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
        
        //删除按钮的点击
        NotificationCenter.default.addObserver(self, selector: #selector(removePhoto), name: NSNotification.Name(rawValue: PicPickerRemovePhoto), object: nil)
    }
}


//MARK:--事件监听
extension ComposeViewController{
    @objc private func closeBtnClick(){
        dismiss(animated: true, completion: nil)
    }
    @objc private func sendBtnClick(){
        
        textView.resignFirstResponder()
        let statusText = textView.getEmoticonString()
        
        //第一张图片上传
        if let image = images.first {
            NetworkTools.shareInstance.sendStatus(statusText: statusText, image: image, isSuccess: { (success) in
                if !success{
                    SVProgressHUD.showError(withStatus: "发送微博失败")
                    return
                }
                SVProgressHUD.showSuccess(withStatus: "发送微博成功")
                self.dismiss(animated: true, completion: nil)
            })
        }else{
            
            NetworkTools.shareInstance.sendStatus(statusText: statusText) { (result) in
                if !result{
                    SVProgressHUD.showError(withStatus: "发送微博失败")
                    return
                }
                SVProgressHUD.showSuccess(withStatus: "发送微博成功")
                self.dismiss(animated: true, completion: nil)
            }
        }
        
       
        
    }
    
    @objc func KeyboardFrameWillShow(notification:NSNotification){
       //1.获取动画时间
        let duration = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! TimeInterval
        
        //2.键盘最终的Y值
        let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        
        //3.计算工具栏距离底部的间距
        let marin =  y - UIScreen.main.bounds.height
        
        //4.执行动画
        toolbarBottomCons.constant =  marin
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    
}

//MARK:-添加照片和删除照片
extension ComposeViewController{
    @objc private func addPhotoClick(){
        //1.判断照片源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        
        //2.创建照片源控制器
        let ipc = UIImagePickerController()
        ipc.sourceType = .photoLibrary
        ipc.delegate = self
        present(ipc, animated: true, completion: nil)
    }
    
    @objc private func removePhoto(note:NSNotification){
        guard let image = note.object as? UIImage else {
            return
        }
        
        guard let index = images.index(of: image) else {
            return
        }
        images.remove(at: index)
        
        picPickerView.images = images
    }
    
}



extension ComposeViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    
        images.append(image)
        //将数据给collectionView,让collectionView自己去展示数据
        picPickerView.images = images
        
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK:--UITextViewDelegate
extension ComposeViewController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.textView.placeHoderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}














