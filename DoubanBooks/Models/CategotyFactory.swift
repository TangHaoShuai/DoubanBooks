//
//  CategotyFactory.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/14.
//  Copyright © 2019年 2017yd. All rights reserved.
//
import CoreData
import Foundation

final class CategotyFactory {
    // 懒汉式单例模式
    var repository:Repositry<VMCategoty>
    private static var instance: CategotyFactory?
    var app:AppDelegate?
    private init(_ app:AppDelegate) {
        repository = Repositry<VMCategoty>(app)
        self.app = app
    }
    
    static func getInstance(_ app:AppDelegate) -> CategotyFactory {
        if let obj = instance{
            return obj
        } else {
            let token = "net.lzzy.factory.category"
            DispatchQueue.once(token: token, block: {
                    if instance == nil{
                        instance = CategotyFactory(app)
                    }
                })
                return instance!
        }
    }
    ///查
    func getAllCategories() throws -> [VMCategoty] {
        return try repository.get()
    }
    
    func getCategoryBy(kw:UUID) throws -> VMCategoty?{
        let category = try repository.getby([VMCategoty.colId], keyword: kw.uuidString)
        if category.count > 0{
            return category[0]
        }
        return nil
    }
    
    func getCategorysBy(kw:VMCategoty) throws -> [VMCategoty] {
        return try repository.getby([VMCategoty.colName], keyword: kw.name!)
    }
    
    
    func getBooksCountOfCategory(category id:UUID)  -> Int? {
        do {
            return try  BookFactory.getInstance(app!).getBooksOf(category: id).count
        } catch {
            return nil
        }
    }
    /// 删
    func removeCategory(category:VMCategoty) throws -> (Bool,String?) {
        if let count =  getBooksCountOfCategory(category: category.id){
            if count > 0{
                return (false ,"存在该类图书，不能删除")
            }
        }else {
            return (false,"无法获取类别信息" )
        }
        do {
            try repository.delete(id: category.id)
            return (true,nil)
        }catch DataError.deleteExistsError(let info){
            return (false ,info)
        }catch {
            return (false, error.localizedDescription)
        }
    }
    ///增
    func addCategory(cattegory: VMCategoty) -> (Bool ,String?) {
        do {
            if try repository.isEntityExists([VMCategoty.colName], keyword: cattegory.name!){
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
    //改
    func updateCategoty(book:VMCategoty) -> (Bool,String?) {
        do{
            try repository.update(vm: book)
            return (true,nil)
        }catch DataError.updateExistsError(let info){
            return (false,info)
        }catch{
            return (false,error.localizedDescription)
        }
    }
    private static let plistName = "CategoryTimeList"
    static func updateEditTime(id:UUID){
        let path = Bundle.main.path(forResource: plistName, ofType: "plist")                          // forResource: 文件名，ofType: 文件类型
        let dic = NSMutableDictionary(contentsOfFile: path!)
        dic?.setObject(Date.dateNowAsString(pattern: "yyyy/MM/dd HH:mm"), forKey: id.uuidString as NSCopying)
        dic?.write(toFile: path!, atomically: true)
    }
    
    static func getEditTimeFromPlist(id:UUID) -> String {
        let path = Bundle.main.path(forResource: plistName, ofType: "plist")                          // forResource: 文件名，ofType: 文件类型
        let dic = NSMutableDictionary(contentsOfFile: path!)
        if let time = dic?[id.uuidString] as? String{
            return time
        }else {
            updateEditTime(id: id)
        }
        return Date.dateNowAsString(pattern: "yyyy/MM/dd HH:mm")
    }
    
    static func removeEditTime(id:UUID){
        let path = Bundle.main.path(forResource: plistName, ofType: "plist")                          // forResource：文件名，ofType:文件类型
        let dic = NSMutableDictionary(contentsOfFile: path!)
        dic?.removeObject(forKey: id.uuidString)
        dic?.write(toFile: path!, atomically: true)
    }
    
}

extension DispatchQueue {
    private static var _onceTracker = [String]()
    public class func once(token: String, block: () -> Void) {
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
