//
//  BroswerViewCell.swift
//  DS11WB
//
//  Created by libo on 2017/10/31.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowerViewDelegate:NSObjectProtocol {
    func imageViewClick()
}

class BroswerViewCell: UICollectionViewCell {
    var picURL :URL? {
        didSet{
          setupContent(picURL: picURL)
        }
    }
    var delegate : PhotoBrowerViewDelegate?
    
    private lazy var scrollView:UIScrollView = UIScrollView()
     lazy var imageView:UIImageView = UIImageView()
    private lazy var progressView:ProgressView = ProgressView()
    //构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BroswerViewCell{
    private func setupUI(){
        //1.添加子控件
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        contentView.addSubview(progressView)
        
        //2.设置frame
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.size.width*0.5, y: UIScreen.main.bounds.size.height*0.5)
        //3.设置属性
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
        
        //4.设置imageView的属性
        imageView.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(imageViewClick))
        imageView.addGestureRecognizer(tapGes)
        
    }
}

extension BroswerViewCell{
    @objc private func imageViewClick(){
        delegate?.imageViewClick()
    }
}
extension BroswerViewCell{
    func setupContent(picURL:URL?) {
        guard let picUrl = picURL else {
            return
        }
        
        //2.设置frame
        let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picUrl.absoluteString)
        //3.计算imageView的frame
        let x :CGFloat = 0
        let width = UIScreen.main.bounds.width
        
        let heigh = (width / (image?.size.width)!)*(image?.size.height)!
        var y:CGFloat = 0
        
        if heigh > UIScreen.main.bounds.height {
            y = 0
        }else{
            y = (UIScreen.main.bounds.height - heigh) * 0.5
        }
        
        imageView.frame = CGRect(x: x, y: y, width: width, height: heigh)
        progressView.isHidden = false
        imageView.sd_setImage(with: getBigUrl(small: picUrl), placeholderImage: image, options: [], progress: { (current, total, url) in
            self.progressView.progress = CGFloat(current)  / CGFloat(total)
        }) { (_, _, _, _) in
            self.progressView.isHidden = true
        }
        
        scrollView.contentSize = CGSize(width: 0, height: heigh)
    }
    
    private func getBigUrl(small:URL)->URL{
        let  smallURLString = small.absoluteString
      let bigString  = smallURLString.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        
        return URL(string: bigString)!
    }
}



