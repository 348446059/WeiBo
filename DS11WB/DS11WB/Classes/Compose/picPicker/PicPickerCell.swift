//
//  PicPickerCell.swift
//  DS11WB
//
//  Created by libo on 2017/10/29.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit

class PicPickerCell: UICollectionViewCell {
    
    //MARK:--控件属性
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    @IBOutlet weak var removePhotoBtn: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    var image:UIImage? {
        didSet{
            if image != nil{
                imageView.image = image
                addPhotoBtn.isUserInteractionEnabled = false
                removePhotoBtn.isHidden = false
            }else{
                imageView.image = nil
                addPhotoBtn.isUserInteractionEnabled = true
                removePhotoBtn.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBAction func addPhotoCilci(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
       
        
    }
    
    @IBAction func removePhotoClick(_ sender: Any) {
        
           NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerRemovePhoto), object: imageView.image)
    }
}
