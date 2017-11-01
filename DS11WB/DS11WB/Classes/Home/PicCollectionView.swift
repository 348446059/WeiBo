//
//  PicCollectionView.swift
//  DS11WB
//
//  Created by libo on 2017/10/28.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit
import SDWebImage
class PicCollectionView: UICollectionView {
    //MARK:-定义属性
    var picURLs: [URL] = [URL](){
        didSet{
            self.reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
         dataSource = self
          delegate = self
    }

}

//MARK:-collectionView数据源方法
extension PicCollectionView:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCollectionViewCell
        cell.picURL = picURLs[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userInfo = [ShowPhotoBrowserNoteIndexKey:indexPath,ShowPhotoBrowserNoteUrlsKey:picURLs] as [String : Any]
        //发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShowPhotoBrowserNote), object: self, userInfo: userInfo)
        
    }
    
}


extension PicCollectionView:AnimatorPresentedAnimator{
    func startRect(indexPath: IndexPath) -> CGRect {
        //1.获取cell
        let cell = self.cellForItem(at: indexPath)
        
        //2.获取cell的frame
     return   self.convert((cell?.frame)!, to: UIApplication.shared.keyWindow)
    }
    
    func endrect(indexPath: IndexPath) -> CGRect {
        //1.获取该位置的image对象
        let picURL = picURLs[indexPath.item]
        
        let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURL.absoluteString)
        
        //2.计算结束后的frame
        let w = UIScreen.main.bounds.width
        let h = w / (image?.size.width)! * (image?.size.height)!
        var y :CGFloat = 0.0
        
        if h > UIScreen.main.bounds.height {
             y = 0.0
        }else{
            y = (UIScreen.main.bounds.size.height - h) * 0.5
        }
        
        return CGRect(x: 0, y: y, width: w, height: h )
        
    }
    
    func imageView(indexPath: IndexPath) -> UIImageView {
        //创建UIImageView
        let imageView = UIImageView()
        
        let picURL = picURLs[indexPath.item]
        
        let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURL.absoluteString)
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }

}


class PicCollectionViewCell: UICollectionViewCell {
    //定义模型属性
    var picURL:URL?{
        didSet{
            guard let picURL = picURL else {
                return
            }
            iconView.setImageWith(picURL, placeholderImage: #imageLiteral(resourceName: "empty_picture"))
        }
    }
    
    @IBOutlet weak var iconView: UIImageView!
    
}
