 //
//  PhotoBroswer.swift
//  DS11WB
//
//  Created by libo on 2017/11/1.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit
 //面向协议开发
 protocol AnimatorPresentedAnimator:NSObjectProtocol{
    
    func startRect(indexPath:IndexPath) -> CGRect
    func endrect(indexPath:IndexPath) -> CGRect
    func imageView(indexPath:IndexPath) ->UIImageView
    
 }
 
 protocol AnimatorDismissDelagate:NSObjectProtocol {
    func indexPathForDismis() -> IndexPath
    func imageViewForDismis() -> UIImageView
 }
class PhotoBroswerAnimator: NSObject {
    var isPresent = false
    var presentedDelegate :AnimatorPresentedAnimator?
    var dismissDelegate:AnimatorDismissDelagate?
    
    var indexPath:IndexPath?
    
}
 
 
extension PhotoBroswerAnimator:UIViewControllerTransitioningDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
}
 
 extension PhotoBroswerAnimator:UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresent ? animationForPresented(transitionContext: transitionContext) : animationForDismiss(transitionContext: transitionContext)
        
    }
    
    func animationForPresented(transitionContext: UIViewControllerContextTransitioning) {
        //1.取出弹出的view
        let presentedView = transitionContext.view(forKey: .to)
        
        //2.将presentedView添加到容器containerView中
        transitionContext.containerView.addSubview(presentedView!)
        
        //3.执行动画
        
        //3.1 动画开始位置
        guard  let startRecct = presentedDelegate?.startRect(indexPath: indexPath!)else{
            return
        }
        
        //3.2动画对象
        guard let imageView = presentedDelegate?.imageView(indexPath: indexPath!) else{
            return
        }
        
        transitionContext.containerView.addSubview(imageView)
        transitionContext.containerView.backgroundColor = UIColor.black
        imageView.frame = startRecct
    
        presentedView?.alpha = 0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = (self.presentedDelegate?.endrect(indexPath: self.indexPath!))!
        }) { (_) in
            imageView.removeFromSuperview()
            presentedView?.alpha = 1.0
            transitionContext.containerView.backgroundColor = UIColor.clear
            transitionContext.completeTransition(true)
        }
    }
   func animationForDismiss(transitionContext: UIViewControllerContextTransitioning){
    guard let dismissDelegate = dismissDelegate,let presentedDelegate = presentedDelegate else {
        return
    }
    
      //1.取出消失的view
       let dismissView = transitionContext.view(forKey: .from)
          dismissView?.removeFromSuperview()
    
      //2.获取执行动画的imageView
    let imageView = dismissDelegate.imageViewForDismis()
    transitionContext.containerView.addSubview(imageView)
    
    let indexPath = dismissDelegate.indexPathForDismis()
    
       //2.执行动画
    UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
        imageView.frame = presentedDelegate.startRect(indexPath: indexPath)
    }) { (_) in
       
        transitionContext.completeTransition(true)
    }
    }
 }
