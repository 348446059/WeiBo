//
//  PhotoBroswerController.swift
//  DS11WB
//
//  Created by libo on 2017/10/31.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
private let PhotoBrowerCell = "PhotoBrowerCell"
class PhotoBroswerController: UIViewController {
    
    var indexPath :NSIndexPath
    var picUrls :[URL]
    
    private lazy var collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBroswerPhotoViewLayout())
    private lazy var closeBtn:UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14.0, title: "关闭")
    private lazy var saveBtn:UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14.0, title: "保存")
    //自定义构造函数
    init(indexPath:NSIndexPath,picUrls:[URL]) {
       
         self.indexPath = indexPath
         self.picUrls = picUrls
         super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
      
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: false)
    }
    override func loadView() {
        super.loadView()
        view.bounds.size.width += 20
    }
}

//设置UI
extension PhotoBroswerController{
    private func setUI(){
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        collectionView.frame  = view.bounds
        
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        saveBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(closeBtn.snp.bottom)
            make.size.equalTo(closeBtn.snp.size)
        }
        saveBtn.addTarget(self, action: #selector(save), for: .touchUpInside)
        //3.设置collectionView的属性
        collectionView.register(BroswerViewCell.self, forCellWithReuseIdentifier: PhotoBrowerCell)
        collectionView.dataSource = self
        
        
    }
}



extension PhotoBroswerController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowerCell, for: indexPath) as! BroswerViewCell
        cell.picURL = picUrls[indexPath.item]
        cell.delegate = self
        return cell
    }
   
}


extension PhotoBroswerController : PhotoBrowerViewDelegate{
    func imageViewClick() {
        close()
    }
}
extension PhotoBroswerController{
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func save() {
        let cell = collectionView.visibleCells.first as! BroswerViewCell
        guard let image = cell.imageView.image else {
            return
        }
        
        //保存
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    @objc private func image(image:UIImage,didFinishSavingWithError:NSError?,contextInfo:AnyObject){
        var showInfo = ""
        
        if didFinishSavingWithError != nil {
            showInfo = "保存失败"
        }else{
            showInfo = "保存成功"
        }
        
        SVProgressHUD.showInfo(withStatus: showInfo)
    }
    
}

//MARK:--AnimatorDismissDelegate
extension PhotoBroswerController:AnimatorDismissDelagate{
    func indexPathForDismis() -> IndexPath {
        //获取当前正在显示的IndexPath
        let cell = collectionView.visibleCells.first
        
        return collectionView.indexPath(for: cell!)!
    }

    func imageViewForDismis() -> UIImageView {
        let imageView = UIImageView()
        
        let cell = collectionView.visibleCells.first as! BroswerViewCell
        imageView.frame = cell.imageView.frame
        imageView.image = cell.imageView.image
        
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    
    
}
class PhotoBroswerPhotoViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        itemSize = collectionView!.frame.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection  = .horizontal
        
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    
    }
}











