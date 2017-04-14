//
//  CollCollectionViewCell.swift
//  AlbumCollectionDemo
//
//  Created by kuailao_2 on 17/4/12.
//  Copyright © 2017年 kuailao_2. All rights reserved.
//

import UIKit

class CollCollectionViewCell: UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var delegate : PhotoGalleryViewDelegate?
    var sectionNumber:Int = 0{
        didSet{
            collectionView.contentOffset = CGPoint.init()
            collectionView .reloadData()
        }
    }
    
    private var collectionView:UICollectionView!
    private var catchImageDic : [Int : [UIImage]] = [:]
    private var catchBrowseDic : [Int : [UIImage]] = [:]
    private var cellSide:CGFloat!
    private lazy var browseView:BrowseView = {
        let view = BrowseView.init(frame: CGRect(x:0, y:0, width:SCREEN_WIDTH, height:SCREEN_HEIGHT))
        view.downloadSucBlock = {
            print("下载图片成功")
        }
        view.downloadFailBlock = {
            print("下载图片失败")
        }
        UIApplication.shared.keyWindow?.addSubview(view)
        return view
    }()
    
    // MARK: - system
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - private
    func setUp() {
        
        collectionView = self.createCollectionView(toTop: 0, itemSize:CGSize(width:(SCREEN_WIDTH-40)/3.0, height:(SCREEN_WIDTH-40)/3.0), sectionInset: UIEdgeInsetsMake(10, 10, 10, 10), direction: .vertical)
        collectionView.delegate = self
        collectionView.dataSource = self
        self.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCellID")
        //
        cellSide = (SCREEN_WIDTH-40)/3.0
    }
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let delegate = delegate {
            return delegate.photoGallery(numberOfImagesInSection : sectionNumber)
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCellID", for: indexPath)
        cell.backgroundColor = UIColor.init(white: 0.8, alpha: 1)
        
        let subViewArr = cell.contentView.subviews
        var imageV:UIImageView
        if subViewArr.count > 0 {
            imageV = subViewArr[0] as! UIImageView
        }else{
            imageV = UIImageView.init(frame: CGRect(x:0, y:0, width:cellSide, height:cellSide))
        }
        if let catchImage = catchImageDic[sectionNumber]?[indexPath.row] {
            imageV.image = catchImage
            cell.contentView.addSubview(imageV)
            return cell
        }
        
        if let delegate = delegate {
            imageV = delegate.photoGallery(imageViewForItemAtIndexPath: IndexPath.init(row: indexPath.row, section: sectionNumber))
            if let img = imageV.image  {
                catchBrowseDic[sectionNumber]?[indexPath.row] = img
            }
            let newImage = UIImage.compressAndCutImage(image: imageV.image, size: CGSize(width:cellSide, height:cellSide))
            if let newImage = newImage {
                catchImageDic[sectionNumber]?[indexPath.row] = newImage
                imageV.image = newImage
                imageV.frame.size = CGSize.init(width: cellSide, height: cellSide)
                cell.contentView.addSubview(imageV)
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        browseView.delegate = delegate
        browseView.catchDataDic = catchBrowseDic
        if let delegate = delegate {
            browseView.totleNumber = delegate.photoGallery(numberOfImagesInSection : sectionNumber)
        }
        browseView.showBrowseView(selSection: sectionNumber, selIndex: indexPath.row)
    }
}
