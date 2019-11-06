//
//  BookFactory.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/14.
//  Copyright © 2019年 2017yd. All rights reserved.
//
import CoreData
import Foundation
let MzznotiCategory = "Mzz.notiCategory"
final class BookFactory {
    // 懒汉式单例模式
    var repository:Repositry<VMBook>
    private static var instance: BookFactory?
    
    private init(_ app:AppDelegate) {
        repository = Repositry<VMBook>(app)
    }
    
    static func getInstance(_ app:AppDelegate) -> BookFactory {
        if let obj = instance{
            return obj
        } else {
            let token = "net.lzzy.factory.book"
            DispatchQueue.once2(token: token, block: {
                if instance == nil{
                    instance = BookFactory(app)
                }
            })
            return instance!
        }
    }
    
    func getAllBook() throws -> [VMBook] {
        return try repository.get()
    }
    
    
    ///根据类别id精确查询
    func getBooksOf(category id:UUID) throws -> [VMBook] {
        return try repository.getby([VMBook.colCaregoryId], keyword: id.uuidString)
    }
    /// 根据书名、出版社、简介、isbn13模糊查询
    func getBooksBy(kw:String) throws -> [VMBook] {
        return try repository.get([VMBook.colTitle,VMBook.colIsbn13,VMBook.colAuthor,VMBook.colPublisher,VMBook.colSummary], keyword: kw)
    }
    /// 根据书本的ID来精确查询
    func getBookBy(id:UUID) throws -> VMBook? {
        let book = try repository.getby([VMBook.colId], keyword: id.uuidString)
        if book.count > 0{
            return book[0]
        }
        return nil
    }
    
    

    func isBookExists(book: VMBook) throws -> Bool {
        var match10 = false
        var match13 = false
        if let isbn10 = book.isbn10 {
            if isbn10.count > 0{
                match10 = try  repository.isEntityExists([VMBook.colIsbn10], keyword: isbn10)
            }
        }
        if let isbn13 = book.isbn13 {
            if isbn13.count > 0{
                match13 = try  repository.isEntityExists([VMBook.colIsbn13], keyword: isbn13)
            }
        }
        return match10 || match13
    }
    ///添加图书
    ///
    func addBook(book: VMBook) -> (Bool ,String?) {
        do {
//            if try repository.isEntityExists([book.title!], keyword: book.title!){
//                return (false , "同样的书籍已经存在")
//            }
            try repository.insert(vm: book)
            /// NotificationCenter：通知中心,default: 整个应用默认的通知中心
         NotificationCenter.default.post(name: NSNotification.Name(MzznotiCategory), object: nil)
            
            return (true, nil)
        }catch DataError.entityExistsError(let info){
            return (false,info)
        }catch {
            return (false,error.localizedDescription)
        }
    }
    
    
    /// 更新图书
    func updateBook(book:VMBook) -> (Bool,String?) {
        do{
            try repository.update(vm: book)
            return (true,nil)
        }catch DataError.updateExistsError(let info){
            return (false,info)
        }catch{
            return (false,error.localizedDescription)
        }
    }
   
    //删除书籍
    func removeBook(book: VMBook) throws -> (Bool,String?) {
        do {
            if let isbn13 = book.isbn13 {
                let books = try repository.getby([VMBook.colIsbn13], keyword: isbn13)
                if books.count > 0 {
                    try repository.delete(id: books[0].id)
                NotificationCenter.default.post(name: NSNotification.Name(MzznotiCategory), object: nil)
                    return (true, nil)
                }
                return (false, "没有找到本地数据，是否已删除？")
            } else if let isbn10 = book.isbn10 {
                let books = try repository.getby([VMBook.colIsbn10], keyword: isbn10)
                if books.count > 0 {
                    try repository.delete(id: books[0].id)
                     NotificationCenter.default.post(name: NSNotification.Name(MzznotiCategory), object: nil)
                    return (true, nil)
                }
                return (false, "没有找到本地数据，是否已删除？")
            }
            return (false, "请求删除的数据不完整")
        } catch DataError.deleteExistsError(let info) {
            return (false, info)
        } catch DataError.readCollectionError(let info) {
            return (false, info)
        } catch {
            return (false, error.localizedDescription)
        }
    }
    
//    func removeBook(id: UUID) throws ->(Bool,String?) {
//        do{
//            try repository.delete(id: id)
//            return(true,nil)
//        }catch DataError.deleteExistsError(let info){
//            return (false,info)
//        }catch{
//            return (false,error.localizedDescription)
//        }
//    }
    
}

extension DispatchQueue {
    private static var _onceTracker = [String]()
    public class func once2(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}
