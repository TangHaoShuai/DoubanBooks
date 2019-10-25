//
//  BookRepository.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/14.
//  Copyright © 2019年 2017yd. All rights reserved.
//
import CoreData
import Foundation

class BookRepository{
    var app:AppDelegate
    var context:NSManagedObjectContext
    
    init(_ app:AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    
    func insert(vm:VMBook ) throws {
//        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
//        fetch.predicate = NSPredicate(format: "id = %@", vm.id.uuidString)
//        let result = try context.fetch(fetch) as! [Book]
//        if result.count > 0{
//            for item in result {
//                item.id = vm.id
//                item.title = vm.title
//                item.image = vm.image
//                item.author = vm.author
//                item.authorIntro = vm.authorIntro
//                item.binding = vm.binding
//                item.categoryId = vm.categoryId
//                item.isbn10 = vm.isbn10
//                item.isbn13 = vm.isbn13
//                item.pages = vm.pages
//                item.price = vm.price
//                item.pubdate = vm.pubdate
//                item.publisher = vm.publisher
//                item.summary = vm.summary
//            }
//            app.saveContext()
//        }else{
            let description = NSEntityDescription.entity(forEntityName:VMBook.entityName, in: context)
            let book = NSManagedObject(entity: description!, insertInto: context)
            book.setValue(vm.id, forKey: VMBook.colId)
            book.setValue(vm.title, forKey: VMBook.colTitle)
            book.setValue(vm.image, forKey: VMBook.colImage)
            book.setValue(vm.categoryId, forKey: VMBook.colCaregoryId)
            book.setValue(vm.author, forKey: VMBook.colAuthor)
            book.setValue(vm.authorIntro, forKey: VMBook.colAuthorIntro)
            book.setValue(vm.binding, forKey: VMBook.colBinding)
            book.setValue(vm.isbn10, forKey: VMBook.colIsbn10)
            book.setValue(vm.isbn13, forKey: VMBook.colIsbn13)
            book.setValue(vm.pages, forKey: VMBook.colPages)
            book.setValue(vm.price, forKey: VMBook.colPrice)
            book.setValue(vm.pubdate, forKey: VMBook.colPubdate)
            book.setValue(vm.publisher, forKey: VMBook.colPublisher)
            book.setValue(vm.summary, forKey: VMBook.colSummary)
            app.saveContext()
//        }
    }
    
    func isExists(name: String) throws -> Bool {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: "\(VMBook.colIsbn10) = %@ || \(VMBook.colIsbn13) = %@", name,name)
        do {
            let result = try context.fetch(fetch) as! [VMBook]
            return result.count > 0
        } catch {
            throw DataError.entityExistsError("判断存在数据失败")
        }
    }
    
    func getBook(keyword  format:String,args:[Any]) throws -> [VMBook] {
        var books = [VMBook]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: format, argumentArray: args)
        do {
            let result = try context.fetch(fetch) as! [Book]
            for item in result {
                let vm = VMBook()
                vm.id = item.id!
                vm.title = item.title
                vm.image = item.image
                vm.author = item.author
                vm.authorIntro = item.authorIntro
                vm.binding = item.binding
                vm.categoryId = item.categoryId!
                vm.isbn10 = item.isbn10
                vm.isbn13 = item.isbn13
                vm.pages = item.pages
                vm.price = item.price
                vm.pubdate = item.pubdate
                vm.publisher = item.publisher
                vm.summary = item.summary
                books.append(vm)
            }
        }catch{
            throw DataError.readCollectionError("读取集合数据失败！")
        }
        return books
    }
    
    func delete(id:UUID) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
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
    
    func update(vm:VMBook) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", vm.id.uuidString)
        do{
            let  obj = try context.fetch(fetch)[0] as! NSManagedObject
            obj.setValue(vm.title, forKey: VMBook.colTitle)
            obj.setValue(vm.image, forKey: VMBook.colImage)
            obj.setValue(vm.author, forKey: VMBook.colAuthor)
            obj.setValue(vm.authorIntro, forKey: VMBook.colAuthorIntro)
            obj.setValue(vm.binding, forKey: VMBook.colBinding)
            obj.setValue(vm.isbn10, forKey: VMBook.colIsbn10)
            obj.setValue(vm.isbn13, forKey: VMBook.colIsbn13)
            obj.setValue(vm.pages, forKey: VMBook.colPages)
            obj.setValue(vm.price, forKey: VMBook.colPrice)
            obj.setValue(vm.pubdate, forKey: VMBook.colPubdate)
            obj.setValue(vm.publisher, forKey: VMBook.colPublisher)
            obj.setValue(vm.summary, forKey: VMBook.colSummary)
            app.saveContext()
        } catch {
            throw DataError.updateExistsError("更新图书失败！")
        }
    }
}
