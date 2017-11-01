//
//  HomeViewCell.swift
//  DS11WB
//
//  Created by libo on 2017/10/27.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit
import SDWebImage
import HYLabel
private let edgeMargin:CGFloat = 15
private let itemMargin:CGFloat = 10

class HomeViewCell: UITableViewCell {
  //MARK：属性
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var screenName: UILabel!
    
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var contentWidth: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: HYLabel!
    @IBOutlet weak var soucreLabel: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    
    @IBOutlet weak var retweenTextTopCons: NSLayoutConstraint!
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
    
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var picView: PicCollectionView!
    
    @IBOutlet weak var revertLabel: HYLabel!
    
    var viewModel:StatusViewModel?{
        didSet{
            //1.nil值校验
            guard let viewModel = viewModel else {
                return
            }
            //2.设置头像
            iconView.setImageWith(viewModel.profileUrl!, placeholderImage: #imageLiteral(resourceName: "avatar_default"))
            
            //3.设置认证图标
            verifiedView.image = viewModel.verifiedImage
            
            //4.昵称
            screenName.text = viewModel.status?.user?.screen_name
            
            //5.会员图标
            vipView.image = viewModel.vipImage
            
            //6.设置时间
            timeLabel.text = viewModel.createAtText
            
            //7.设置来源
            contentLabel.attributedText = FindEmoticon.shareIntance.findAttrString(statusText: viewModel.status?.text, font: contentLabel.font)
            
            soucreLabel.text  = "来自 " + (viewModel.sourceText ?? "")
            //8.设置昵称的文字颜色
            screenName.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
            
            //9.计算picView宽度和高度的约束
            let picViewSize = calculatePicViewSize(count: viewModel.picURLs.count)
            picViewWCons.constant = picViewSize.width
            picViewHCons.constant = picViewSize.height
            
            //10.将picURLs数据传给picView
            picView.picURLs = viewModel.picURLs
            
            //11.设置转发微博
            if viewModel.status?.retweeted_status != nil {
               //1.设置转发正文
                if let screenName =  viewModel.status?.retweeted_status?.user?.screen_name, let retweentedText = viewModel.status?.retweeted_status?.text{
                    let retweetedContentLabel = "@" + "\(screenName): " + retweentedText
                    
                    revertLabel.attributedText  = FindEmoticon.shareIntance.findAttrString(statusText: retweetedContentLabel, font: revertLabel.font)
                    //设置转发正文距离顶部的约束
                    retweenTextTopCons.constant = 15
                }
                //2.设置转发微博背景
                bgView.isHidden = false
            }else{
                revertLabel.text = nil
                bgView.isHidden = true
                retweenTextTopCons.constant = 0
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentWidth.constant = UIScreen.main.bounds.width - 2 * edgeMargin
        bgView.autoresizingMask = .flexibleTopMargin
     
        revertLabel.matchTextColor = UIColor.orange
    }
   
}

//MARK:--计算
extension HomeViewCell{
    private func calculatePicViewSize(count:Int) -> CGSize {
         //1.没有配图
        if count == 0{
            picViewBottomCons.constant = 0
            return CGSize.zero
        }
        
        picViewBottomCons.constant = 10
        //2.取出picView的layout
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        
       
        //3.单张配图
        if count == 1 {
            //1.取出图片
            let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: viewModel?.picURLs.first?.absoluteString)
            //设置一张图片的itemSize
            layout.itemSize = CGSize(width: (image?.size)!.width * 2, height: (image?.size)!.height * 2)
            
            return CGSize(width: (image?.size)!.width * 2, height: (image?.size)!.height * 2)
        }
        //4.计算出来的imageViewWH
        let imageViewWH = (UIScreen.main.bounds.width - 2*edgeMargin - 2*itemMargin) / 3
        
        //5.设置多张图片的itemSize
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH )
        
     
        //6.四张配图
        if count == 4 {
            let picViewWH = imageViewWH * 2 + itemMargin + 1
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        //7.1.其它
        let rows = CGFloat((count - 1)/3 + 1)
        
        //7.2 计算picView高度
        let picViewH = rows * imageViewWH + (rows - 1)*itemMargin
        
        //7.3 计算picView宽度
        let picViewW = UIScreen.main.bounds.width - 2*edgeMargin
         return CGSize(width: picViewW, height: picViewH )
        
    }
}


