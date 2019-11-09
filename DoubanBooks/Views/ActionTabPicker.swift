//
//  ActionTabeViewPicker.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/11/8.
//  Copyright © 2019年 2017yd. All rights reserved.
//

import UIKit

class ActionTabePicker: UIView {
    let rowHeight = 60
    var onRect=UIScreen.main.bounds
    var delegate : UITableViewDelegate?
    var dataSource : UITableViewDataSource?
    
    var offRect: CGRect = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        return CGRect(x: 0,y: h,width: w,height: h)
    }()
    var  bgMask: UIView = {
        let mView = UIView()
        mView.backgroundColor = UIColor.lightGray
        mView.alpha = 0.5
        return mView
    }()
    
    func addTitle(title:String,itemsCount: Int)  {
        let n: Int = {
            if itemsCount < 6 {
                return itemsCount
            }
            return 6
        }()
        let y = self.bounds.height - CGFloat(n * rowHeight + rowHeight + 20 + +rowHeight + 10 + 2)
        let lblTiele = UILabel (frame: CGRect(x: 20, y: y, width: self.bounds.width - 40, height: CGFloat(rowHeight + 10)))
        lblTiele.textAlignment = .center
        lblTiele.backgroundColor = UIColor.white
        lblTiele.textColor = UIColor.black
        lblTiele.font = UIFont.boldSystemFont(ofSize: 20)
        lblTiele.text = title
        self.addSubview(lblTiele)
        
    }
    
    fileprivate func addTableView(_ count: Int){
        let n: Int = {
            if count < 6 {
                return count
            }
            return 6
        }()
          let y = self.bounds.height - CGFloat(n * rowHeight + rowHeight + 20)
          let table = UITableView(frame: CGRect(x: 20, y: y, width: UIScreen.main.bounds.width - 40, height: CGFloat(rowHeight * n)))
        table.dataSource = dataSource
        table.delegate = delegate
        
        self.addSubview(table)
        
    }
    
    func addCancel()  {
        let btn = UIButton(type:  .custom)
        btn.frame = CGRect(x: 20, y: self.bounds.height - CGFloat(rowHeight), width: self.bounds.width - 40, height: CGFloat(rowHeight))
        btn.backgroundColor = UIColor.white
        btn.setTitleColor(UIColor.red, for:  .normal)
        btn.setTitle("取消", for: .normal)
        btn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        self.addSubview(btn)
        
    }
    @objc func cancel(){
        UIView.animate(withDuration: 0.5, animations:{() -> Void in
            self.frame = self.offRect
        },completion: { over  in
            self.removeFromSuperview()
        })
    }
    init(title: String,count: Int,dataSoure: UITableViewDataSource,delegate: UITableViewDelegate) {
        super.init(frame: onRect)
        self.dataSource = dataSoure
        self.delegate = delegate
        self.frame = offRect
        self.backgroundColor = UIColor.clear
        self.bgMask.frame = self.bounds
        bgMask.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancel)))
        self.addSubview(bgMask)
        addCancel()
        addTitle(title: title, itemsCount: count)
        addTableView(count)
    }
 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(superView: UIView) ->ActionTabePicker{
        UIView.animate(withDuration: 0.4, animations: {
            self.frame = self.onRect
            self.removeFromSuperview()
            superView.addSubview(self)
        })
        return self
    }

}
