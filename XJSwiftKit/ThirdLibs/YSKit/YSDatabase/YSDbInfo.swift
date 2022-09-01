//
//  YSDbInfo.swift
//  LeiFengHao
//
//  Created by xj on 2021/10/18.
//

import UIKit

// MARK: - demoTest
class YSDbInfo: NSObject {

    var name: String = ""
    var age: Int = 0
}

extension YSDbInfo: YSDbProtocol {

    /// 从DB读取数据模型
    static func getDbInfo(_ tableName: String, _ resultSet: FMResultSet) -> Any? {
        let dbInfo = YSDbInfo()
        dbInfo.name = resultSet.string(forColumn: USER_COLUMN_NAME) ?? ""
        dbInfo.age = resultSet.long(forColumn: USER_COLUMN_AGE)
        return dbInfo
    }

    func getInfoKeyValues() -> (keys: [String]?, values: [String]?) {
        var keyArray = [String]()
        var valueArray = [String]()

        keyArray.append(USER_COLUMN_NAME)
        valueArray.append(DB.toSqlValue(value: self.name))

        keyArray.append(USER_COLUMN_AGE)
        valueArray.append(DB.toSqlValue(value: String(format: "%d", self.age)))

        return (keyArray, valueArray)
    }
}
