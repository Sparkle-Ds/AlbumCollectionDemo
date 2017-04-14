//
//  PhotoGalleryView.swift
//  AlbumCollectionDemo
//
//  Created by kuailao_2 on 17/4/12.
//  Copyright © 2017年 kuailao_2. All rights reserved.
//

/// 相册视图

protocol PhotoGalleryViewDelegate {
    func photoGallery(imageViewForItemAtIndexPath indexPath: IndexPath) -> UIImageView
    func photoGallery(numberOfImagesInSection section: Int) -> Int
}

import UIKit

class PhotoGalleryView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate {
    
    var delegate : PhotoGalleryViewDelegate?
    var topTitleView:ScrollBtnsView!
    
    private var bottomScrollView:UICollectionView!
    
    // MARK: - system method
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
    // MARK: private method
    func setUp() {
        topTitleView = ScrollBtnsView.init(frame: CGRect(x:0, y:0, width:SCREEN_WIDTH, height:50))
        topTitleView.clickBlock = { (tag) in
            self.bottomScrollView.contentOffset = CGPoint(x:CGFloat(tag)*SCREEN_WIDTH, y:0)
        }
        self.addSubview(topTitleView)
    
        bottomScrollView = self.createCollectionView(toTop: 50, itemSize:CGSize(width:SCREEN_WIDTH, height:self.frame.height-50), sectionInset: UIEdgeInsets.zero , direction: .horizontal)
        bottomScrollView.delegate = self
        bottomScrollView.dataSource = self
        bottomScrollView.isPagingEnabled = true
        self.addSubview(bottomScrollView)
       
        bottomScrollView.register(CollCollectionViewCell.self, forCellWithReuseIdentifier: "CollCollectionViewCellID")
    }
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topTitleView.titleArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollCollectionViewCellID", for: indexPath) as! CollCollectionViewCell
        cell.delegate = delegate;
        cell.sectionNumber = indexPath.row
        return cell
    }
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offSetFlag = Int(scrollView.contentOffset.x/SCREEN_WIDTH)
        topTitleView.upDataOldAndNewBtn(newRow: offSetFlag)
        
    }
}
