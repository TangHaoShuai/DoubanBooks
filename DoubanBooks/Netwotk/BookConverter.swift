//
//  BookConverter.swift
//  DoubanBooks
//
//  Created by 2017yd2 on 2019/10/30.
//  Copyright © 2019 2017yd. All rights reserved.


import Foundation

class BookConverter  {
    
    static func getBooks(json:Any) ->[VMBook]?{
        var books:[VMBook]?
        let dic = json as! Dictionary<String,Any>
        if dic [sbcount] as!  Int > 0 {
            books = JSONConveryer<VMBook>.getArray(json: json, key: sbbooks)
        }
        return books
    }
    
     static func getBook(json:Any) -> VMBook{
     return JSONConveryer<VMBook>.getSingle(json: json)
     }
}


