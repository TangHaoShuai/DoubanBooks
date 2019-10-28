//
//  jsonable.swift
//  DoubanBooks
//
//  Created by 2017yd2 on 2019/10/28.
//  Copyright © 2019 2017yd. All rights reserved.
//    @NSManaged public var author: String?
//@NSManaged public var authorIntro: String?
//@NSManaged public var categoryId: UUID?
//@NSManaged public var id: UUID?
//@NSManaged public var image: String?
//@NSManaged public var isbn10: String?
//@NSManaged public var isbn13: String?
//@NSManaged public var pages: Int32
//@NSManaged public var price: String?
//@NSManaged public var pubdate: String?
//@NSManaged public var publisher: String?
//@NSManaged public var summary: String?
//@NSManaged public var title: String?
//@NSManaged public var binding: String?


import Foundation
   let sbbooks = "books"
   let sbcount = "count"
   let sbstart = "start"
   let sbtotal = "total"
   let sbauthor = "authro"
   let sbauthorIntro = "author_intro"
   let sbimage = "image"
   let sbisbn10 = "isbn10"
   let sbisbn13 = "isbn13"
   let sbpages = "pages"
   let sbprice = "price"
   let sbpubdate = "pubdate"
   let sbpublisher = "publisher"
   let sbsummary = "summary"
   let sbtitle = "title"
   let sbbinding = "binding"
   let sbid = "id"
   

class  ApiParameters {
    static func getSearchUrl(keyword:String,page:Int)-> String {
        let url = "https://douban.uieee.com/v2/book/search?q=" + keyword + "&start=" + String(page * 20)
        return url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}
protocol JSONable  {
    init(json: Dictionary<String, Any>)
}


class testJOSN {
    let jsons = jsonuiols.getSearchUrl(keyword: "", page: 10)
    
}
