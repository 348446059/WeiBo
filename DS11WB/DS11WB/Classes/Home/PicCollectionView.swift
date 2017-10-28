//
//  PicCollectionView.swift
//  DS11WB
//
//  Created by libo on 2017/10/28.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit

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
        
    }

}

//MARK:-collectionView数据源方法
extension PicCollectionView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCollectionViewCell
        cell.picURL = picURLs[indexPath.item]
        
        return cell
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
