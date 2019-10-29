//
//  File.swift
//  DoubanBooks
//
//  Created by 2017yd2 on 2019/10/29.
//  Copyright © 2019 2017yd. All rights reserved.
//

import Foundation
class JSONConveryer <T: JSONable>{
    
    ///解析格式为[{} ,{},{}] 的josn 数据
    /// -Parameter josnArray：josn 数据
    /// -Retures : JSONBLE 对象的集合
    static func getArray(jsonArray: Array<Any> )-> [T] {
        var array = [T]()
        for json in jsonArray {
            let t = T(json:json as! Dictionary<String,Any>)
            array.append(t)
        }
        
        return array
    }
    /// 解析格式为{"key":[{},{},{}],"key1":"xxx"...0} 的josn数据
    static func getArray(json:Any ,key:String) -> [T] {
        var array = [T]()
        let dic = json as! Dictionary<String ,Any>
        let josnArray = dic[key] as! Array<Any>
        
        for json in josnArray {
            let t = T(json:json as! Dictionary<String,Any>)
            array.append(t)
        }
        
        return array
    }
    
//    static func getSingle(json :Any) -> T{
//
//
//    }

//    static func getSingle(json:Any ,key:String) ->T {
//         let dic = json as! Dictionary<String ,Any>
//        dic = dic[key] as! Array<Any>
//    }
}
