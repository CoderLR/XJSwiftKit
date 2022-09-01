//
//  YSDbTool.swift
//  LeiFengHao
//
//  Created by xj on 2021/10/18.
//

import UIKit

// MARK: - 存储的对象需要实现以下协议
protocol YSDbProtocol: NSObject {
    
    /// 子类继承用于从DB读取数据转换为模型
    static func getDbInfo(_ tableName: String, _ resultSet: FMResultSet) -> Any?
    
    /// 子类继承用户获取模型的键值
    func getInfoKeyValues() -> (keys: [String]?, values: [String]?)
}

// MARK: - SQL管理类
class YSDbTool: NSObject {
    
    // 单例
    static let share = YSDbTool()
    
    // 数据库管理类
    private var database = FMDatabase()
    
    override init() {
        super.init()
        
        let bdPath: String = FileManager.xj.DocumnetsDirectory() + "/xjjy.db"
        
        print("dbPath: \(bdPath)")
        database = FMDatabase(path: bdPath)
        if !database.open() {
            print("dayabase open fail!")
        }
    }
}

// MARK: - 数据库增删改查
extension YSDbTool {
    
    /// 创建表
    /// - Parameter tableName: 表名
    @discardableResult
    func createTable(_ tableName: String) -> Bool {
        
        // 已经创建表
        if query(tableName) { return true }
        
        // 开始创建
        let sql = create(tableName)
        let isSuccess = database.executeUpdate(sql, withArgumentsIn: [])
        if isSuccess {
            print("createTable: success")
        }
        return isSuccess
    }
    
    /// 数据库增加
    /// - Parameters:
    ///   - tableName: 表名
    ///   - dbInfo: 存储模型
    @discardableResult
    func insertTable<T: YSDbProtocol>(_ tableName: String, dbInfo: T) -> Bool {
        guard let keyArray = dbInfo.getInfoKeyValues().0 else { return false }
        guard let valueArray = dbInfo.getInfoKeyValues().1 else { return  false }
        guard let sql = insertTable(tableName, keyArray: keyArray, valueArray: valueArray) else { return false }
        let isSuccess = database.executeUpdate(sql, withArgumentsIn: [])
        if isSuccess {
            print("insertTable: success")
        }
        return isSuccess
    }
    
    /// 数据库更新
    /// - Parameters:
    ///   - tableName: 表名
    ///   - dbInfo: 存储模型
    @discardableResult
    func updateTable<T: YSDbProtocol>(_ tableName: String, dbInfo: T, column: String, columnValue: String) -> Bool {
        guard let keyArray = dbInfo.getInfoKeyValues().0 else { return false }
        guard let valueArray = dbInfo.getInfoKeyValues().1 else { return false }
        guard let sql = updateTable(tableName, keyArray: keyArray, valueArray: valueArray, column: column, columnValue: columnValue) else { return false }
        let isSuccess = database.executeUpdate(sql, withArgumentsIn: [])
        if isSuccess {
            print("updateTable: success")
        }
        return isSuccess
    }
    
    /// 数据库查询->id
    /// - Parameters:
    ///   - tableName: 表名
    ///   - dbInfo: 转换模型
    /// - Returns: 返回查询数组
    @discardableResult
    func queryTable<T: YSDbProtocol>(_ tableName: String, column: String = COMMON_COLUMN_ID, asc: Bool = false, dbInfo: T.Type) -> [Any]? {
        guard let sql = queryTable(tableName, column: column, asc: asc) else { return nil }
        guard let reslutSet = database.executeQuery(sql, withArgumentsIn: []) else { return nil }
        var reslutArray: [Any] = []
        while reslutSet.next() {
            if let info = T.getDbInfo(tableName, reslutSet) {
                reslutArray.append(info)
            }
        }
        return reslutArray
    }
    
    /// 数据库查询->条件
    /// - Parameters:
    ///   - tableName: 表名
    ///   - dbInfo: 转换模型
    /// - Returns: 返回查询数组
    @discardableResult
    func queryTable<T: YSDbProtocol>(_ tableName: String, dbInfo: T.Type, key: String, value: String) -> [Any]? {
        guard let sql = queryTable(tableName, key: key, value: value) else { return nil }
        guard let reslutSet = database.executeQuery(sql, withArgumentsIn: []) else { return nil }
        var reslutArray: [Any] = []
        while reslutSet.next() {
            if let info = T.getDbInfo(tableName, reslutSet) {
                reslutArray.append(info)
            }
        }
        return reslutArray
    }
    
    /// 数据库删除
    /// - Parameters:
    ///   - tableName: 表名
    ///   - dbInfo: 模型
    @discardableResult
    func deleteTable(_ tableName: String, key: String, value: String) -> Bool {
        
        guard let sql = deleteTable(tableName, key: key, value: value) else { return false }
        let isSuccess = database.executeUpdate(sql, withArgumentsIn: [])
        if isSuccess {
            print("deleteTable: success")
        }
        return isSuccess
    }
    
    /// 数据库删除
    /// - Parameters:
    ///   - tableName: 表名
    ///   - dbInfo: 模型
    @discardableResult
    func deleteAllTable(_ tableName: String) -> Bool {
        
        guard let sql = deleteAllTable(tableName) else { return false }
        let isSuccess = database.executeUpdate(sql, withArgumentsIn: [])
        if isSuccess {
            print("deleteAllTable: success")
        }
        return isSuccess
    }
}

// MARK: - 表数据相关
extension YSDbTool {
    
    /// 数据库插入操作
    /// - Parameters:
    ///   - tableName: 表名
    ///   - keyArray: 表键数组
    ///   - valueArray: 表值数组
    /// - Returns: sql
    private func insertTable(_ tableName: String, keyArray: [Any], valueArray: [Any]) -> String? {
        
        if tableName == "" {
            print("insertTable: tableName is nil")
            return nil
        }
        
        if keyArray.count != valueArray.count {
            print("insertTable: keyArray.count != valueArray.count")
            return nil
        }
        
        var sql = String(format: "insert into %@ (", tableName)
        
        for i in 0..<keyArray.count {
            let key = keyArray[i] as? String ?? ""
            if i == keyArray.count - 1 {
                sql.append(" " + key + " ")
            } else {
                sql.append(" " + key + " ,")
            }
        }
        
        sql.append(" ) values ( ")
        
        for i in 0..<valueArray.count {
            let value = valueArray[i] as? String ?? ""
            if i == keyArray.count - 1 {
                sql.append(" " + value + " ")
            } else {
                sql.append(" " + value + " ,")
            }
        }
        
        sql.append(" )")
        print("insertTable: \(sql)")
        return sql
    }
    
    /// 数据库更新操作
    /// - Parameters:
    ///   - tableName: 表名
    ///   - keyArray: 表键数组
    ///   - valueArray: 表值数组
    /// - Returns: sql
    private func updateTable(_ tableName: String, keyArray: [Any], valueArray: [Any], column: String, columnValue: String) -> String?  {
        if tableName == "" {
            print("updateTable: tableName is nil")
            return nil
        }
        
        if keyArray.count != valueArray.count {
            print("updateTable: keyArray.count != valueArray.count")
            return nil
        }
        
        var sql = String(format: "update %@ set ", tableName)
        for i in 0..<keyArray.count {
            let key = keyArray[i] as? String ?? ""
            let value = valueArray[i] as? String ?? ""
            
            if i == keyArray.count - 1 {
                let string = String(format: " %@=%@ ", key, value)
                sql.append(string)
            } else {
                let string = String(format: " %@=%@ ,", key, value)
                sql.append(string)
            }
        }
        
        sql.append(String(format: "where %@ = %@", column, toSqlValue(value: columnValue)))
        
        print("updateTable: \(sql)")
        return sql
    }
    
    /// 数据库删除操作
    /// - Parameters:
    ///   - tableName: 表名
    ///   - key: 键
    ///   - value: 值
    /// - Returns: sql
    private func deleteTable(_ tableName: String, key: String, value: String) -> String? {
        if tableName == "" {
            print("deleteTable: tableName is nil")
            return nil
        }
        
        let sql = String(format: "delete from %@ where %@ = %@", tableName, key, "'\(value)'")
        print("deleteTable: \(sql)")
        return sql
    }
    
    /// 数据库删除操作所有
    /// - Parameters:
    ///   - tableName: 表名
    ///   - key: 键
    ///   - value: 值
    /// - Returns: sql
    private func deleteAllTable(_ tableName: String) -> String? {
        if tableName == "" {
            print("deleteTable: tableName is nil")
            return nil
        }
        
        let sql = String(format: "delete from %@ where 1 = 1", tableName)
        print("deleteAllTable: \(sql)")
        return sql
    }
    
    /// 数据库查询操作->id
    /// - Parameters:
    ///   - tableName: 表名
    ///   - column: 列名
    /// - Returns: sql
    private func queryTable(_ tableName: String, key: String, value: String) -> String? {
        if tableName == "" {
            print("queryTable: tableName is nil")
            return nil
        }
        
        let sql = String(format: "select * from %@ where %@ = %@", tableName, key, value)
        print("queryTable: \(sql)")
        return sql
    }
    
    /// 数据库查询操作->条件
    /// - Parameters:
    ///   - tableName: 表名
    ///   - column: 列名
    /// - Returns: sql
    private func queryTable(_ tableName: String, column: String, asc: Bool = false) -> String? {
        if tableName == "" {
            print("queryTable: tableName is nil")
            return nil
        }
        
        let sort = asc ? "asc" : "desc"
        let sql = String(format: "select * from %@ order by %@ %@", tableName, column, sort)
        print("queryTable: \(sql)")
        return sql
    }
    
    /// 对键值进行字符格式化
    /// - Parameter value: 键值
    /// - Returns: 格式化后的字符串
    func toSqlValue(value: String) -> String {
        if value == "" { return "''" }
        var retVal = String(value)
        let range = retVal.startIndex..<retVal.endIndex
        retVal.replacingOccurrences(of: "'", with: "''", options: String.CompareOptions.caseInsensitive, range: range)
        retVal.insert("'", at: retVal.startIndex)
        retVal.append("'")
        return retVal
    }
}

// MARK: - 表操作相关
extension YSDbTool {
    /// 表创建
    /// - Parameter tableName: 表名
    /// - Returns: sql
    private func create(_ tableName: String) -> String {
        
        if tableName == "" {
            print("insertTable: tableName is nil")
            return ""
        }
        
        var sql = "create table if not exists "
        sql.append(tableName)
        sql.append(" ( ")

        sql.append(String(format: "%@ %@, ", COMMON_COLUMN_ID, "integer primary key autoincrement"))
        
        /// 用户表
        if tableName == USER_TABLE_NAME {
            sql.append(String(format: "%@ %@, ", USER_COLUMN_NAME, "text"))
            sql.append(String(format: "%@ %@", USER_COLUMN_AGE, "text"))
            
        /// 搜索表
        } else if tableName == SEARCH_TABLE_NAME {
            sql.append(String(format: "%@ %@, ", SEARCH_COLUMN_TIME, "text"))
            sql.append(String(format: "%@ %@", SEARCH_COLUMN_CONTENT, "text"))
        }
        
        sql.append(" )")
        print("createTable: \(sql)")
        return sql
    }

    /// 查询表有没有创建
    /// - Parameter tableName: 表名
    /// - Returns: 是否创建
    private func query(_ tableName: String) -> Bool {
        let sql = String(format: "select count(*) count from sqlite_master where type='table' and name='%@'", tableName)
        guard let reslutSet = database.executeQuery(sql, withArgumentsIn: []) else { return false }
    
        var isCreate = true
        while reslutSet.next() {
            let count = reslutSet.string(forColumn: "count")
            print("count:\(count ?? "")")
            if count ?? "" == "0" {
                isCreate = false
            }
        }
        return isCreate
    }
    
    /// 从数据库删除表
    /// - Parameter tableName: 表名
    /// - Returns: 是否删除成功
    func drop(_ tableName: String) -> Bool {
        let sql = String(format: "drop table %@", tableName)
        let isSuccess = database.executeUpdate(sql, withArgumentsIn: [])
        if isSuccess {
            print("drop: success")
        }
        return isSuccess
    }
}
