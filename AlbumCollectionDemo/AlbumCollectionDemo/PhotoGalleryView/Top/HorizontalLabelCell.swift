//
//  HorizontalLabelCell.swift
//  AlbumCollectionDemo
//
//  Created by kuailao_2 on 17/4/12.
//  Copyright © 2017年 kuailao_2. All rights reserved.
//


import UIKit

class HorizontalLabelCell: UITableViewCell {
    var cellLabel = UILabel()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUp()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUp() {
        cellLabel = UILabel.init(frame: self.frame)
        cellLabel.font = UIFont.systemFont(ofSize: 15)
        cellLabel.textAlignment = .center
        self.contentView.addSubview(cellLabel)
    }
}
