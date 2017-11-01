//
//  ProgressView.swift
//  DS11WB
//
//  Created by libo on 2017/10/31.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    var progress :CGFloat = 0{
        didSet{
            setNeedsDisplay()
        }
    }
    
   
    override func draw(_ rect: CGRect) {
        super.draw(rect)
       //1.设置参数
        let center = CGPoint(x: rect.width*0.5, y: rect.height*0.5)
        let radius = rect.width * 0.5 - 3
        let startAngle = CGFloat(-Double.pi / 2)
        let endAngle = CGFloat(2 * Double.pi) * progress + startAngle
        
        //2.创建贝塞尔曲线
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        //3.绘制一条中心点的线
        path.addLine(to: center)
        path.close()
        
        //4.设置绘制颜色
        UIColor(white: 1.0, alpha: 0.4).setFill()
        
        //5.开始绘制
        path.fill()
        
    }
   

}
