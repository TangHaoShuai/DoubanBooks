//
//  BookFactory.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/14.
//  Copyright © 2019年 2017yd. All rights reserved.
//
import CoreData
import Foundation
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
    
//    func getAllBook() throws -> [VMBook] {
//        return try repository.get()
//    }
    
    
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
    func addBook(cattegory: VMBook) -> (Bool ,String?) {
        do {
            if try repository.isEntityExists([cattegory.title!], keyword: cattegory.title!){
                return (false , "同样的类别已经存在")
            }
            try repository.insert(vm: cattegory)
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
    ///删除图书
    func removeBook(id: UUID) throws ->(Bool,String?) {
        do{
            try repository.delete(id: id)
            return(true,nil)
        }catch DataError.deleteExistsError(let info){
            return (false,info)
        }catch{
            return (false,error.localizedDescription)
        }
    }
    
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
