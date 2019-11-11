//
//  ActionCollectionPicker.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/11/8.
//  Copyright © 2019年 2017yd. All rights reserved.
//

import UIKit

// TOOD: 自定义单元格
class ActionCollectionCell: UICollectionViewCell {
    var lblTitle: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        lblTitle = UILabel()
        lblTitle.font = UIFont.systemFont(ofSize: 13)
        lblTitle.textAlignment = .center
        lblTitle.textColor = UIColor.black
        self.addSubview(lblTitle)
        self.backgroundColor = UIColor.white
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.lblTitle.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 60)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
// TODO: 自定义类
class ActionCollectionPickerts: UIView {
    var delegate: UICollectionViewDelegate?
    var dataSource: UICollectionViewDataSource?
    let rowHeight = 60
    var onRect = UIScreen.main.bounds
    var offRect: CGRect = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        return CGRect(x: 0, y: h, width: w, height: h)
    }()
    var bgMask: UIView = {
        let mask = UIView()
        mask.backgroundColor = UIColor.lightGray
        mask.alpha = 0.5
        return mask
    }()
    // TODO: 标题
    fileprivate func addTitle(title: String, itemsCount: Int) {
        let n: Int = {
            if itemsCount < 3 {
                return itemsCount
            }
            return 3
        }()
        let y = self.bounds.height - CGFloat(n * rowHeight + rowHeight + 20 + rowHeight + 40 + 2 )
        let lblTitle  = UILabel(frame: CGRect(x: 20, y: y, width: self.bounds.width - 40, height: CGFloat(rowHeight + 10)))
        lblTitle.textAlignment = .center
        lblTitle.backgroundColor = UIColor.white
        lblTitle.textColor = UIColor.black
        lblTitle.font = UIFont.boldSystemFont(ofSize: 20)
        lblTitle.text = title
        self.addSubview(lblTitle)
    }
    // TODO: CollectionView数据源
    fileprivate func addCollectionView(_ count: Int, reuseId: String) {
        let n: Int = {
            if count < 3 {
                return count
            }
            return 3
        }()
        let y = self.bounds.height - CGFloat(n * (rowHeight + 10) + rowHeight + 20 + 20)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: CGFloat((UIScreen.main.bounds.width - 80)/3), height: CGFloat(rowHeight))
        layout.minimumInteritemSpacing = CGFloat(10)
        layout.minimumLineSpacing = CGFloat(10)
        let tabel = UICollectionView(frame: CGRect(x: 20, y: y, width: UIScreen.main.bounds.width - 40, height: CGFloat(n * (rowHeight + 10) + 10)), collectionViewLayout: layout)
        tabel.dataSource = dataSource
        tabel.delegate = delegate
        tabel.register(ActionCollectionCell.self, forCellWithReuseIdentifier: reuseId)
        tabel.backgroundColor = UIColor.groupTableViewBackground
        tabel.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.addSubview(tabel)
    }
    fileprivate func getRows(count: Int) {
        let n: Int = {
            if count < 3 {
                return count
            }
            return 3
        }()
    }
    // TODO: 取消
    fileprivate func addCancel() {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 20, y: self.bounds.height - CGFloat(rowHeight), width: self.bounds.width - 40 , height: CGFloat(rowHeight))
        btn.backgroundColor = UIColor.white
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.setTitle("取消", for: .normal)
        btn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        self.addSubview(btn)
    }
    @objc func cancel() {
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.frame = self.offRect
        }, completion: { over in
            self.removeFromSuperview()
        })
    }
    // TODO: 构造器
    init(title: String, count: Int,dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate,reuseId: String) {
        super.init(frame: onRect)
        self.dataSource = dataSource
        self.delegate = delegate
        self.frame = offRect
        self.backgroundColor = UIColor.clear
        self.bgMask.frame = self.bounds
        bgMask.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancel)))
        self.addSubview(bgMask)
        addTitle(title: title, itemsCount: count)
        addCollectionView(count, reuseId: reuseId)
        addCancel()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // TODO: 选择器
    func show(superView: UIView) -> ActionCollectionPickerts {
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.frame = self.onRect
            self.removeFromSuperview()
            superView.addSubview(self)
        })
        return self
    }
}
