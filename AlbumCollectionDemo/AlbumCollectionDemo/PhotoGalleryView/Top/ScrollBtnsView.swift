//
//  ScrollBtnsView.swift
//  AlbumCollectionDemo
//
//  Created by kuailao_2 on 17/4/12.
//  Copyright © 2017年 kuailao_2. All rights reserved.
//

/// 顶部可滚动按钮视图 (按钮宽度自适应文字长度)

import UIKit

class ScrollBtnsView: UIView ,UITableViewDelegate,UITableViewDataSource{
    var clickBlock:((_ tag:Int)->())?
    var titleArr:[String] = [] {
        didSet{
            if titleArr.count == 0 {
                self.frame = CGRect.zero
            }
            var allLength:CGFloat = 0
            for titleStr in titleArr {
                let curLength = self.getStrLength(str: titleStr as NSString)+60
                lengthArr.append(curLength)
                pointXArr.append(allLength)
                allLength += curLength
            }
            viewLength = allLength
            
            //
            flagView.frame = CGRect(x:0, y:0, width:2, height:lengthArr[0])
            tbView.reloadData()
        }
    }
    private var tbView:UITableView!
    private var flagView:UIView!
    private var earlierFlag:Int = 0
    private var lengthArr:[CGFloat] = []
    private var pointXArr:[CGFloat] = []
    private var viewLength:CGFloat = 0{
        didSet{
            if viewLength<SCREEN_WIDTH {
                var newLengthArr:[CGFloat] = []
                var newPonitXArr:[CGFloat] = []
                var aLength:CGFloat = 0
                for length in lengthArr {
                    let newLength = (length*SCREEN_WIDTH)/viewLength
                    newLengthArr.append(newLength)
                    newPonitXArr.append(aLength)
                    aLength += newLength
                }
                lengthArr = newLengthArr
                pointXArr = newPonitXArr
                viewLength = SCREEN_WIDTH
            }
        }
    }
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
    func setUp() {
        tbView = UITableView.init(frame: CGRect(x:0, y:0, width:self.frame.height, height:SCREEN_WIDTH), style: .plain)
        tbView.showsVerticalScrollIndicator = false
        tbView.scrollsToTop = false
        tbView.separatorStyle = .none
        tbView.delegate = self
        tbView.dataSource = self
        tbView.center = CGPoint(x:SCREEN_WIDTH/2.0, y:self.frame.height/2.0)
        tbView.transform = CGAffineTransform(rotationAngle: -CGFloat(M_PI)/2)
        self.addSubview(tbView)
        //
        flagView = UIView.init(frame: CGRect(x:0, y:0, width:2, height:0))
        flagView.backgroundColor = UIColor.red
        tbView.addSubview(flagView)
        //
        let lineView = UIView.init(frame: CGRect(x:0, y:self.frame.height-1, width:self.frame.width, height:1))
        lineView.backgroundColor = UIColor.init(white: 0.8, alpha: 1)
        self.addSubview(lineView)
    }
    func getStrLength(str:NSString) -> CGFloat {
        let attributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 15)]
        let size = str.size(attributes: attributes)
        return size.width
    }
    // MARK: - public method
    /**
     更新旧按钮和新按钮的状态
     
     - parameter newRow: 新按钮所在位置
     */
    func upDataOldAndNewBtn(newRow:Int)  {
        let newIndexPath = IndexPath.init(row: newRow, section: 0)
        let earlierCell:HorizontalLabelCell? = tbView.cellForRow(at: IndexPath.init(row: earlierFlag, section: 0)) as! HorizontalLabelCell?
        earlierCell?.cellLabel.textColor = UIColor.gray
        let curCell = tbView.cellForRow(at: newIndexPath)  as! HorizontalLabelCell?
        curCell?.cellLabel.textColor = UIColor.red
        let curY = pointXArr[newRow]
        let curH = lengthArr[newRow]
        UIView.animate(withDuration: 0.3, animations: {
            self.flagView.frame = CGRect(x:0, y:curY, width:2, height:curH )
        })
        if viewLength>SCREEN_WIDTH {
            var offSet:CGFloat = 0
            if (viewLength-curY)<SCREEN_WIDTH{
                offSet = viewLength-SCREEN_WIDTH
            }else{
                offSet = curY + curH/2.0-SCREEN_WIDTH/2.0
            }
            if offSet < 0 {
                offSet = 0
            }
            if offSet > viewLength - SCREEN_WIDTH{
                offSet = viewLength - SCREEN_WIDTH
            }
            UIView.animate(withDuration: 0.3) {
                self.tbView.contentOffset = CGPoint(x:0, y:offSet)
            }
        }
        earlierFlag = newRow
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return lengthArr[indexPath.row]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "HorizontalLabelCell"
        var cell:HorizontalLabelCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as! HorizontalLabelCell?
        if cell == nil {
            cell = HorizontalLabelCell.init(style: .default, reuseIdentifier: cellID)
            cell?.selectionStyle = .none
            cell?.transform =  CGAffineTransform(rotationAngle: CGFloat(M_PI)/2)
        }
        cell?.cellLabel.text = titleArr[indexPath.row]
        cell?.cellLabel.frame = CGRect(x:0, y:0, width:lengthArr[indexPath.row], height:self.frame.height)
        if indexPath.row == earlierFlag {
            cell?.cellLabel.textColor = UIColor.red
        }else{
            cell?.cellLabel.textColor = UIColor.gray
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.upDataOldAndNewBtn(newRow: indexPath.row)
        if let clickBlock = clickBlock {
            clickBlock(indexPath.row)
        }
    }
}
