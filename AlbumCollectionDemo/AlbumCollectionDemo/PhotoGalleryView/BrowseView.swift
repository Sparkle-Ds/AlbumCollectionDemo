//
//  BrowseView.swift
//  AlbumCollectionDemo
//
//  Created by DS on 17/4/12.
//  Copyright © 2017年 First Cloud. All rights reserved.
//

/// 相册浏览视图

import UIKit

class BrowseView: UIView,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate {
    
    var delegate : PhotoGalleryViewDelegate?
    var downloadSucBlock:(()->())?
    var downloadFailBlock:(()->())?
    var catchDataDic : [Int : [UIImage]] = [:]
    var totleNumber = 0

    private var collectionView:UICollectionView!
    private var indexLabel:UILabel!
    private var downBtn:UIButton!
    private var indexNumber:Int = 0
    private var sectionNumber:Int = 0
    private var catchFrameDic : [Int : [CGRect]] = [:]
    
    // MARK: - system method
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - private method
    private func setUp() {
        
        collectionView = self.createCollectionView(toTop: 0, itemSize: CGSize(width:SCREEN_WIDTH, height:self.frame.height), sectionInset: UIEdgeInsets.zero, direction: .horizontal)
        collectionView.backgroundColor = UIColor.black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        self.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "BrowseCellID")
        
        let pointX = (SCREEN_WIDTH-100)/2.0
        indexLabel = UILabel.init(frame: CGRect(x:pointX, y:SCREEN_HEIGHT-40, width:100, height:20))
        indexLabel.textColor = UIColor.white
        indexLabel.font = UIFont.systemFont(ofSize: 15)
        indexLabel.textAlignment = .center
        self.addSubview(indexLabel)
        
        downBtn = UIButton.init(type: .custom)
        downBtn.frame = CGRect(x:SCREEN_WIDTH - 45, y:SCREEN_HEIGHT - 45, width:25, height:25)
        downBtn.setImage(UIImage.init(named: "down_image"), for: .normal)
        downBtn.addTarget(self, action: #selector(downBtnAction), for: .touchUpInside)
        self.addSubview(downBtn)
        self.isHidden = true
    }
    func downBtnAction() {
        let downLoadImage = self.delegate?.photoGallery(imageViewForItemAtIndexPath: IndexPath.init(row: indexNumber, section: sectionNumber)).image
        if let downLoadImage = downLoadImage {
            UIImageWriteToSavedPhotosAlbum(downLoadImage, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject){
        if let didFinishSavingWithError = didFinishSavingWithError {
            print(didFinishSavingWithError)
            if let downloadFailBlock = downloadFailBlock {
                downloadFailBlock()
            }
        }else{
            if let downloadSucBlock = downloadSucBlock {
                downloadSucBlock()
            }
        }
    }
    func pinchAction(gesture:UIPinchGestureRecognizer) {
        if  let view = gesture.view{
            let originFrame = view.frame
            let scale = gesture.scale
            view.transform = view.transform.scaledBy(x: scale, y: scale)
            gesture.scale = 1
            if view.frame.size.width < SCREEN_WIDTH {
                UIView.animate(withDuration: 0.3, animations: {
                    view.frame = originFrame
                })
            }
        }
    }
    func getNewFrame(frame:CGRect) -> CGRect {
        if  frame.width/SCREEN_WIDTH != frame.height/SCREEN_HEIGHT{
            let newH = SCREEN_WIDTH*frame.height/frame.width
            let newPointY = (SCREEN_HEIGHT-newH)/2.0
            if frame.width/SCREEN_WIDTH > frame.height/SCREEN_HEIGHT {
                return CGRect(x:0, y:newPointY, width:SCREEN_WIDTH, height:newH)
            }else{
                return CGRect(x:0, y:0, width:SCREEN_WIDTH, height:newH)
            }
        }else{
            return CGRect(x:0, y:0, width:SCREEN_WIDTH, height:SCREEN_HEIGHT)
        }
    }
    // MARK: - public method
    /**
     展示图片浏览图
     
     - parameter selSection: 点击的图片属于第几组
     - parameter selIndex: 点击的图片索引
     */
    func showBrowseView(selSection:Int, selIndex:Int) {
        self.isHidden = false
        sectionNumber = selSection
        indexNumber = selIndex
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath.init(row: indexNumber, section: 0), at: .right, animated: false)
        indexLabel.text = String(format: "%ld / %ld",indexNumber+1,totleNumber)
    }
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totleNumber
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowseCellID", for: indexPath)
        cell.backgroundColor = UIColor.black
        
        let subViewArr = cell.contentView.subviews
        var imageV:UIImageView!
        if subViewArr.count > 0 {
            imageV = subViewArr[0] as! UIImageView
        }else{
            imageV = UIImageView.init(frame: CGRect(x:0, y:0, width:SCREEN_WIDTH, height:SCREEN_WIDTH))
            imageV.isUserInteractionEnabled = true
            let pinchGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchAction(gesture:)))
            imageV.addGestureRecognizer(pinchGesture)
        }
        if let catchImage = catchDataDic[sectionNumber]?[indexPath.row] {
            imageV.image = catchImage
            cell.contentView.addSubview(imageV)
        }else{
            if let delegate = delegate {
                imageV = delegate.photoGallery(imageViewForItemAtIndexPath: IndexPath.init(row: indexPath.row, section: sectionNumber))
                if let img = imageV.image  {
                    catchDataDic[sectionNumber]?[indexPath.row] = img
                }
            }
        }
        var newFrame:CGRect!
        if let catchFrame = catchFrameDic[sectionNumber]?[indexPath.row] {
            newFrame = catchFrame
        }else{
            newFrame = self.getNewFrame(frame: imageV.frame)
            catchFrameDic[sectionNumber]?[indexPath.row] = newFrame
        }
        imageV.frame = newFrame
        if  newFrame.height > SCREEN_HEIGHT{
            let scrollView = UIScrollView.init(frame: CGRect(x:0, y:0, width:SCREEN_WIDTH, height:SCREEN_HEIGHT))
            scrollView.addSubview(imageV)
            scrollView.contentSize = CGSize(width:SCREEN_WIDTH, height:newFrame.height)
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(removeFromSuperview))
            imageV.addGestureRecognizer(tapGesture)
            cell.addSubview(scrollView)
        }else{
            cell.addSubview(imageV)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.isHidden = true
    }
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        indexNumber = Int(scrollView.contentOffset.x/SCREEN_WIDTH)
        indexLabel.text = String(format: "%ld / %ld",indexNumber+1,totleNumber)
    }
    
}
