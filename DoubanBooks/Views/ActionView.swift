//
//  ActionView.swift
//  DoubanBooks
//
//  Created by 2017yd2 on 2019/11/7.
//  Copyright © 2019 2017yd. All rights reserved.
//

import UIKit


class ActionView<T:PickerModeleDelegate> : UIView {
    var rowHeight = 60
    var onRect =  UIScreen.main.bounds
    var offRect: CGRect = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        return CGRect(x: 0, y: h, width: w, height: h)
    }()
    
    var bgMask: UIView = {
        let mView = UIView()
        mView.backgroundColor = UIColor.lightGray
        mView.alpha = 0.5
        return mView
    }()
    
    var delegate : PickerItemSelectedDelete?
    
  private func addTitle(title: String,itemsCount: Int) {
        let y = self.bounds.height - CGFloat(itemsCount * rowHeight + rowHeight + 20 + rowHeight + 10 + 2)
        let lblTitle = UILabel(frame: CGRect(x: 20, y: y, width: self.bounds.width - 40, height: CGFloat(rowHeight + 10)))
        lblTitle.textAlignment = .center
        lblTitle.backgroundColor = UIColor.white
        lblTitle.textColor = UIColor.black
        lblTitle.font = UIFont.boldSystemFont(ofSize: 20)
        lblTitle.text = title
        self.addSubview(lblTitle)
    }
    private    func AddItems(_ items:[T]){
        var pos = 0
        let separartiegeight = 1
        for item in items {
            let btn  = UIButton(type: .custom)
            let countOfBelow  = items.count - pos
            let y = self.bounds.height - CGFloat(countOfBelow * rowHeight + rowHeight + 20)
            btn.frame = CGRect(x: 20, y: y, width: self.bounds.width - 40, height:CGFloat(rowHeight) )
            btn.backgroundColor = UIColor.white
            btn.tag = pos
            pos += 1
            btn.setTitle(item.title, for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.addTarget(self, action: #selector(itemsSelected(_:)), for: .touchUpInside)
           let separator = UIView(frame: CGRect(x: 0, y: CGFloat(rowHeight - separartiegeight), width: self.bounds.width - 40, height: 1))
            separator.backgroundColor = UIColor.darkGray
            btn.addSubview(separator)
            self.addSubview(btn)
        }
    }
    private   func addCancel(){
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 20, y: self.bounds.height - CGFloat(rowHeight), width: self.bounds.width - 40, height: CGFloat(rowHeight))
        btn.backgroundColor = UIColor.white
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.setTitle("取消", for: .normal)
        btn.addTarget(self, action: #selector(cancel), for:.touchUpInside)
        self.addSubview(btn)
    }
    @objc func  itemsSelected(_ btn: UIButton){
        cancel()
        self.delegate?.itemSelected(index: btn.tag)
    }
    
    @objc func cancel(){
        UIView.animate(withDuration: 0.4, animations: {()-> Void in
            self.frame = self.offRect
        },completion: {
            over in
            self.removeFromSuperview()
        })
    }
    
   init(hander: PickerItemSelectedDelete) {
           super.init(frame: onRect)
           self.delegate = hander
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}
