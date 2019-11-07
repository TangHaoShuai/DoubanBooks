//
//  PickerModelDelegate.swift
//  DoubanBooks
//
//  Created by 2017yd2 on 2019/11/7.
//  Copyright © 2019 2017yd. All rights reserved.
//

import Foundation
protocol PickerModelDelegate {
    var title: String {get}
    var value: Any {get}
}
protocol PickerItemSelectedDelegate {
    func itemSelected(index: Int)
    
}
