//
//  PopverAnimator.swift
//  DS11WB
//
//  Created by libo on 2017/10/21.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit

class PopverAnimator: NSObject {
    //对外提供的属性
    var coverFrame:CGRect = CGRect.zero
    //MARK:--属性
    var isPresented:Bool = false
    
    var callback: ((_ presented : Bool)->())?
    //MARK：--自定义构造函数
    init(callback:@escaping (_ presented : Bool)->()) {
        self.callback = callback
    }
    
    deinit {
        print("来了")
    }
}
//MARK--自定义转场
extension PopverAnimator: UIViewControllerTransitioningDelegate{
    //目的:改变弹出视图的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentController = PresentationController(presentedViewController: presented, presenting: presenting)
        presentController.coverFrame = coverFrame
        return presentController
    }
    //目的:自定义弹出的动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        callback!(isPresented)
        return self
    }
    
    //目的:自定义消息动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        callback!(isPresented)
        return self
    }
}

extension PopverAnimator:UIViewControllerAnimatedTransitioning{
    //动画执行时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    //获取转场的上下文,可以通过转场上下文获取弹出的view和消失的view
    //UITransitionContextViewControllerKey 获取弹出的key
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext: transitionContext) : animationForDismiss(transitionContext: transitionContext)
    }
    
    ///自定义弹出动画
    private func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning){
        //1.获取弹出view
        let presentView = transitionContext.view(forKey: .to)!
        
        //2.将弹出的view添加到containerView中
        transitionContext.containerView.addSubview(presentView)
        
        //3 执行动画
        presentView.transform = CGAffineTransform.init(scaleX: 1.0, y: 0)
        //改编动画锚点
        presentView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            presentView.transform = CGAffineTransform.identity
        }, completion: { (isFinished) in
            transitionContext.completeTransition(true)
        })
    }
    ///自定义消息动画
    private func animationForDismiss(transitionContext: UIViewControllerContextTransitioning){
        //1.获取弹出view
        let dismissView = transitionContext.view(forKey: .from)!
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissView.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.00001)
        }, completion:{ (_) in
            dismissView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
    
}
