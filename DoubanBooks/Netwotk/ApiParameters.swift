
//  Created by 2017yd2 on 2019/10/28.
//  Copyright © 2019 2017yd. All rights reserved.



import Foundation
   let sbbooks = "books"
   let sbcount = "count"
   let sbstart = "start"
   let sbtotal = "total"
   let sbauthor = "author"
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

