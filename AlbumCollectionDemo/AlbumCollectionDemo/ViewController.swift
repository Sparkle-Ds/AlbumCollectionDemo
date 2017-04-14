//
//  ViewController.swift
//  AlbumCollectionDemo
//
//  Created by DS on 17/4/12.
//  Copyright © 2017年 First Cloud. All rights reserved.
//

/*
 这里默认:
        1.相册中图片的大图和小图使用同一个图片
        2.顶部标题视图的高度为50
 */

import UIKit

class ViewController: UIViewController, PhotoGalleryViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "相册"

        let albumView = PhotoGalleryView.init(frame: CGRect(x:0, y:64, width:SCREEN_WIDTH, height:self.view.frame.size.height-64))
        albumView.delegate = self
        albumView.topTitleView.titleArr = ["相册1相册1相册1","2","相册三","相册4相册4","555","6====6====6"]
        self.view.addSubview(albumView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - PhotoGalleryViewDelegate
    internal func photoGallery(numberOfImagesInSection section: Int) -> Int {
        return (section + 1)*3
    }
    internal func photoGallery(imageViewForItemAtIndexPath indexPath: IndexPath) -> UIImageView {
        return UIImageView.init(image: UIImage.init(named: "text_Image"))
    }
    
}

