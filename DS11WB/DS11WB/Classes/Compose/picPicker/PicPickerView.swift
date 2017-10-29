//
//  PicPickerView.swift
//  DS11WB
//
//  Created by libo on 2017/10/29.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit
private let picPickerCell = "picPickerCell"
private let edgeMargin:CGFloat = 10
class PicPickerView: UICollectionView {
    
    var images:[UIImage] = [UIImage](){
        didSet{
            self.reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        
        //设置layout布局
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.main.bounds.width - 4 * edgeMargin) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        
        //设置collection内边距
        contentInset = UIEdgeInsets(top: edgeMargin, left: edgeMargin, bottom: 0, right: edgeMargin)
        register(UINib(nibName: "PicPickerCell", bundle: nil), forCellWithReuseIdentifier: picPickerCell)
       
    }
}

extension PicPickerView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCell, for: indexPath) as! PicPickerCell
        
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        
        return cell
    }
    
    
}
