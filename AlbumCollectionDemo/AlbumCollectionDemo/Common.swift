//
//  Common.swift
//  AlbumCollectionDemo
//
//  Created by DS on 17/4/12.
//  Copyright © 2017年 First Cloud. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

extension UIView{
    /**,
     创建横向滚动视图
     
     - parameter toTop:        与视图顶部的距离
     - parameter itemSize:      cell 的大小
     - parameter sectionInset:   cell 上下左右的间距
     - parameter direction:    滚动方向
     
     - returns: UICollectionView
     */
    func createCollectionView(toTop:CGFloat,itemSize:CGSize,sectionInset:UIEdgeInsets,direction:UICollectionViewScrollDirection)-> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = itemSize
        layout.sectionInset = sectionInset
        layout.minimumLineSpacing = sectionInset.left
        layout.scrollDirection = direction
        let collectionView = UICollectionView.init(frame: CGRect(x:0, y:toTop, width:SCREEN_WIDTH, height:self.frame.height-toTop), collectionViewLayout: layout)
        if direction == .horizontal {
            collectionView.scrollsToTop = false
        }
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }
}

extension UIImage{
    /**
     压缩并裁剪图片
     
     - parameter image: 要压缩的图片
     - parameter size:  目标 size
     
     - returns:  压缩并裁剪后的图片
     */
    class func compressAndCutImage(image:UIImage?,size:CGSize) -> UIImage? {
        if let image = image {
            let imageW = image.size.width
            let imageH = image.size.height
            let widScale = imageW/size.width
            let heiScale = imageH/size.height
            UIGraphicsBeginImageContextWithOptions(size, false,  UIScreen.main.scale)
            if widScale>heiScale {
                image.draw(in: CGRect(x:(size.width-imageW/heiScale)/2.0, y:0, width:imageW/heiScale, height:size.height))
            }else{
                image.draw(in: CGRect(x:0,y:(size.width-imageH/widScale)/2.0, width:size.width, height:imageH/widScale))
            }
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }else{
            return nil
        }
    }
}
