//
//  FuncTools.swift
//  DoubanBooks
//
//  Created by 2017yd2 on 2019/10/24.
//  Copyright © 2019 2017yd. All rights reserved.
// FuncTools

import Foundation
class FuncTools {
//    @discardableResult
    public class func exchangeMethod(cls:AnyClass? ,targetSel:Selector,newSel:Selector) -> Bool{
        guard let before:Method = class_getInstanceMethod(cls, targetSel),
            let after: Method = class_getInstanceMethod(cls, newSel) else {
                return false
        }
        method_exchangeImplementations(before, after)
        return true
    }
}
