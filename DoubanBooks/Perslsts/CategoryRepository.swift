//
//  CategoryRepository.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/12.
//  Copyright © 2019年 2017yd. All rights reserved.
//
import  CoreData
import Foundation
class CategoryRepository{
    var app:AppDelegate
    var context:NSManagedObjectContext
    
    init(_ app:AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    
    func insert(vm:VMCategoty ) throws {
//        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategoty.entityName)
//        fetch.predicate = NSPredicate(format: "id = %@", vm.id.uuidString)
//        let result = try context.fetch(fetch) as! [Category]
//        if result.count > 0{
//            for item in result {
//                item.id = vm.id
//                item.image = vm.image
//                item.name = vm.name
//            }
//            app.saveContext()
//        }else{
            let description = NSEntityDescription.entity(forEntityName:VMCategoty.entityName, in: context)
            let category = NSManagedObject(entity: description!, insertInto: context)
            category.setValue(vm.id, forKey: VMCategoty.colId)
            category.setValue(vm.name, forKey: VMCategoty.colName)
            category.setValue(vm.image, forKey: VMCategoty.colImage)
            app.saveContext()
//        }
    }
    
    func isExists(name: String) throws -> Bool {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategoty.entityName)
        fetch.predicate = NSPredicate(format: "\(VMCategoty.colName) = %@", name)
        do {
            let result = try context.fetch(fetch) as! [VMCategoty]
            return result.count > 0
        } catch {
            throw DataError.entityExistsError("判断存在数据失败")
        }
    }
    
    func getCategory(keyword:String? = nil) throws -> [VMCategoty] {
        var category = [VMCategoty]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategoty.entityName)
        do {
            if let kw = keyword{
            fetch.predicate = NSPredicate(format: "name like[c] %@ ", "*\(kw)*")
            }
            let result = try context.fetch(fetch) as! [Category]
            for item in result {
                let vm = VMCategoty()
                vm.id = item.id!
                vm.name = item.name
                vm.image = item.image
                category.append(vm)
            }
        }catch{
            throw DataError.readCollectionError("读取集合数据失败！")
        }
        return category
    }
    
    func delete(id:UUID) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategoty.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", id.uuidString)
        do {
            let result = try context.fetch(fetch)
            for m in result{
                context.delete(m as! NSManagedObject)
            }
            app.saveContext()
        }catch {
            throw DataError.deleteExistsError("c删除图书失败！")
        }
    }
    
    
}
