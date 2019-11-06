//
//  Repositry.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/15.
//  Copyright © 2019年 2017yd. All rights reserved.
//
/**
    /// 通用的
 */
import CoreData
import Foundation
class Repositry<T:DataViewModilDelegate> where T:NSObject{
    var app:AppDelegate
    var context:NSManagedObjectContext
    
    init(_ app:AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    /// 添加一条新的数据
    func insert(vm:T ) throws {
        let description = NSEntityDescription.entity(forEntityName:T.entityName, in: context)
        let obj = NSManagedObject(entity: description!, insertInto: context)
        for (key,value) in vm.entityPairs() {
            obj.setValue(value, forKey: key)
        }
        app.saveContext()
    }
    
    /// 根据条件判断实体类是否存在
    ///
    /// - parameter cols: 查询条件要比配的列
    //通用的存在的持久化数据
    func isEntityExists(_ cols: [String],keyword: String) throws -> Bool {
          var format = ""
          var args = [String]()
          for col in cols {
              format += "\(col) = %@ || "
              args.append(keyword)
          }
          format.removeLast(3)
          let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
          fetch.predicate = NSPredicate(format: format, argumentArray: args)
          do{
              let result = try context.fetch(fetch)
              return result.count > 0
          }catch {
              throw DataError.entityExistsError("判断数据存在失败 ")
          }
      }
    
//    func isEntityExists(_ cols: [String], keyword: String) throws -> Bool {
//        var format = ""
//        var args = [String]()
//        for col in cols {
//            format += "\(col) = %@ || "
//            args.append(keyword)
//        }
//        format.removeLast(3)
//        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
//        fetch.predicate = NSPredicate(format: format, argumentArray: args)
//        do {
//            let result = try context.fetch(fetch)
//            return result.count > 0
//        } catch {
//            throw DataError.entityExistsError("判断存在的数据失败")
//        }
//    }
    
    /// 获取所有数据
    ///
    /// 根据传入的关键字查找数据, 模糊搜索
    /// - cols：要匹配的列
    /// - keyword： 要搜索的关键字
    /// - result：视图模型对象集合
    func get(_ cols:[String]? = nil, keyword:String? = nil) throws -> [T] {
        var books = [T]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        
        do {
            let result = try context.fetch(fetch)
            for item in result {
                let vm = T()
                vm.packageSelf(result: item as! NSFetchRequestResult)
                books.append(vm)
            }
        }catch{
            throw DataError.readCollectionError("读取集合数据失败！")
        }
        return books
    }
    
    /// 获取所有数据
    ///
    /// 根据传入的关键字查找数据, 精确搜索
    /// - cols：要匹配的列
    /// - keyword： 要搜索的关键字
    /// - result：视图模型对象集合
    func getby(_ cols:[String], keyword:String) throws -> [T] {
        var format = ""
        var args = [String]()
        for col in cols {
            format += "\(col) = %@ || "
            args.append(keyword)
        }
        format.removeLast(3)
        
        var books = [T]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: format, argumentArray: args)
        do {
            let result = try context.fetch(fetch)
            for item in result {
                let vm = T()
                vm.packageSelf(result: item as! NSFetchRequestResult)
                books.append(vm)
            }
        }catch{
            throw DataError.readCollectionError("读取集合数据失败！")
        }
        return books
    }
    
    
    /// 获取所有数据
    ///
    /// 根据传入的关键字查找数据, 精确搜索
    /// - cols：要匹配的列
    /// - keyword： 要搜索的关键字
    /// - result：视图模型对象集合
    func getbykey(_ cols:[String], keyword:String) throws -> [T] {
        var format = ""
        var args = [String]()
        for col in cols {
            format += "\(col) lick[c] %@ || "
            args.append("*\(keyword)*")
        }
        format.removeLast(4)
        
        var books = [T]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: format, argumentArray: args)
        do {
            let result = try context.fetch(fetch)
            for item in result {
                let vm = T()
                vm.packageSelf(result: item as! NSFetchRequestResult)
                books.append(vm)
            }
        }catch{
            throw DataError.readCollectionError("读取集合数据失败！")
        }
        return books
    }
    
    
    /// 删除指定数据
    ///
    /// - id: 要删除数据的id
    func delete(id:UUID) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", id.uuidString)
        do {
            let result = try context.fetch(fetch)
            for m in result{
                context.delete(m as! NSManagedObject)
            }
            app.saveContext()
        }catch {
            throw DataError.deleteExistsError("删除图书失败！")
        }
    }
    
    /// 更新指定数据
    func update(vm:T) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", vm.id.uuidString)
        do{
            let  obj = try context.fetch(fetch)[0] as! NSManagedObject
            for (key,value) in vm.entityPairs() {
                obj.setValue(value, forKey: key)
            }
            app.saveContext()
        } catch {
            throw DataError.updateExistsError("更新图书失败！")
        }
    }
    
}
