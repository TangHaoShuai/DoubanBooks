//
//  CollectionViewExtension.swift
//  DoubanBooks
//
//  Created by retry on 2018/11/19.
//  Copyright © 2018 retry. All rights reserved.
//
import Foundation
import UIKit

private let EmptyViewTag = 12345
extension UITableView {
    func setEmtpyTableViewDelegate(target: EmptyViewDelegate) {
        emptyDelegate = target
        DispatchQueue.once(token: #function) {
            FuncTools.exchangeMethod(cls: self.classForCoder, targetSel: #selector(self.layoutSubviews), newSel: #selector(self.re_layoutSubviews))
        }
    }
    
    @objc func re_layoutSubviews() {
        self.re_layoutSubviews()
        super.reLayoutSubviews()
    }
}

extension UICollectionView {
    func setEmtpyCollectionViewDelegate(target: EmptyViewDelegate) {
        emptyDelegate = target
        DispatchQueue.once(token: #function) {
            FuncTools.exchangeMethod(cls: self.classForCoder, targetSel: #selector(self.layoutSubviews), newSel: #selector(self.re_layoutSubviews))
        }
    }
    
    @objc func re_layoutSubviews() {
        self.re_layoutSubviews()
        super.reLayoutSubviews()
    }
}

extension UIScrollView {
    func reLayoutSubviews() {
        if emptyDelegate == nil {
            return
        }
        if self.emptyDelegate!.isEmpty {
            guard let view = self.emptyDelegate?.createEmptyView() else {
                return
            }
            if let subView = self.viewWithTag(EmptyViewTag) {
                subView.removeFromSuperview()
            }
            view.tag = EmptyViewTag
            self.addSubview(view)
        } else {
            guard let view = self.viewWithTag(EmptyViewTag) else {
                return
            }
            view .removeFromSuperview()
        }
    }
    //MARK:- ***** Associated Object *****
    private struct AssociatedKeys {
        static var emptyViewDelegate = "scrollView_emptyViewDelegate"
    }
    
    var emptyDelegate: EmptyViewDelegate? {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.emptyViewDelegate) as? EmptyViewDelegate)
        }
        set (newValue){
            objc_setAssociatedObject(self, &AssociatedKeys.emptyViewDelegate, newValue!, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
