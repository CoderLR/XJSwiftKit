//
//  YSCoreDataTool.swift
//  LeiFengHao
//
//  Created by xj on 2022/6/28.
//

import UIKit
import CoreData

/*
 NSManagedObject
 1.NSManagerObjectModel(被管理对象的模型, 实体)
 2.NSEntityDescription (创建实体描述, 实体名必须跟类名相同)
 3.NSFetchRequest (从实体中查询)
 4.NSManagedObjectContext(被管理对象上下文, 临时数据库(添加, 查询, 修改, 删除数据))
 5.NSPrisistenStoreCoordinator(持久化存储助理, 数据库的连接器)
 */

/// coreData工具类
class YSCoreDataTool: NSObject {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.coreDataName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    /// 获取管理的数据上下文对象
    lazy var context: NSManagedObjectContext = {
       return self.persistentContainer.viewContext
    }()
    
    /// coreDataName.xcdatamodeld
    var coreDataName: String = ""
    
    /// 初始化
    /// - Parameter coreDataName: coreDataName.xcdatamodeld
    convenience init(coreDataName: String) {
        self.init()
        
        self.coreDataName = coreDataName
    }
    
    override init() {
        
    }
}

/// 增删改查操作
extension YSCoreDataTool {
    
    /// 添加数据
    @discardableResult
    func addData<T: NSManagedObject>(_ tableName: String, object: T) -> T {
 
        // 创建对象
        var obj = NSEntityDescription.insertNewObject(forEntityName: tableName,
                                                       into: context) as! T
        // 对象赋值
        obj = object

        // 保存
        do {
            try context.save()
            print("保存成功！")
        } catch {
            fatalError("不能保存：\(error)")
        }
        return obj
    }
    
    /// 查询数据
    func queryData<T: NSManagedObject>(_ tableName: String, predicate: NSPredicate) -> [T] {
 
        // 声明数据的请求
        let fetchRequest = NSFetchRequest<T>(entityName: tableName)
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量

        // 设置查询条件
        //let predicate = NSPredicate(format: "id= '1' ", "")
        fetchRequest.predicate = predicate

        // 查询操作
        do {
            let fetchedObjects = try context.fetch(fetchRequest)

            // 返回查询的结果
            return fetchedObjects
        }
        catch {
            fatalError("不能查询：\(error)")
        }
    }
    
    /// 修改数据操作
    @discardableResult
    func modifyData<T: NSManagedObject>(_ tableName: String, predicate: NSPredicate, object: T) -> T? {

        // 声明数据的请求
        let fetchRequest = NSFetchRequest<T>(entityName: tableName)
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量

        // 设置查询条件
        //let predicate = NSPredicate(format: "id= '1' ", "")
        fetchRequest.predicate = predicate

        var info: T?
        // 查询操作
        do {
            let fetchedObjects = try context.fetch(fetchRequest)

            // 遍历查询的结果
            for i in 0..<fetchedObjects.count {
                info = fetchedObjects[i]
                // 修改数据
                info = object
                // 重新保存
                try context.save()
            }
        }
        catch {
            fatalError("不能修改：\(error)")
        }
        return info
    }
    
    /// 删除数据操作
    func deleteData<T: NSManagedObject>(_ tableName: String, predicate: NSPredicate, object: T?) {
        // 声明数据的请求
        let fetchRequest = NSFetchRequest<T>(entityName: tableName)
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量

        // 设置查询条件
        //let predicate = NSPredicate(format: "id= '1' ", "")
        fetchRequest.predicate = predicate

        // 查询操作
        do {
            let fetchedObjects = try context.fetch(fetchRequest)

            //遍历查询的结果
            for info in fetchedObjects{
                //删除对象
                context.delete(info)
            }

            //重新保存-更新到数据库
            try! context.save()
        }
        catch {
            fatalError("不能删除：\(error)")
        }
    }
}
