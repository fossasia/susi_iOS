//
//  TableAction.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-06-10.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import Foundation
import RealmSwift

class Column: Object {
    dynamic var original: String = ""
    dynamic var changed: String = ""

    convenience init(key: String, value: String) {
        self.init()

        self.original = key
        self.changed = value
    }

    static func getColumns(columns: [String : String]) -> List<Column> {
        let cData = List<Column>()
        for column in columns {
            cData.append(Column(key: column.key, value: column.value))
        }
        return cData
    }

}

class TableData: Object {
    dynamic var data: String = ""

    convenience init(data: [String : AnyObject]) {
        self.init()

        self.data = "\(data)"
    }

    static func getTableData(data: [[String : AnyObject]]) -> List<TableData> {
        let tData = List<TableData>()
        for record in data {
            let d = TableData(data: record)
            tData.append(d)
        }
        return tData
    }

}

class TableAction: Message {
    dynamic var size: Int = 0
    var columns = List<Column>()
    var tableData = List<TableData>()

    convenience init(data: [[String : AnyObject]], actionObject: [String : AnyObject]) {
        self.init()

        if let count = actionObject[Client.ChatKeys.Count] as? Int, count > 0 {
            self.size = count
        }

        if let columns = actionObject[Client.ChatKeys.Columns] as? [String : String] {
            self.columns = Column.getColumns(columns: columns)
        }

        self.tableData = TableData.getTableData(data: data)
    }

}
