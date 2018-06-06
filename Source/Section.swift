//
//  Section.swift
//  TextureForm
//
//  Created by Liu on 2018/2/12.
//  Copyright © 2018年 grace.app. All rights reserved.
//

import Foundation

public struct Section {
    
    public var title: String?
    public var rows: [Row]
    
    public var headerHeight: CGFloat?
    public var tag: String
    
    public init(title: String? = nil, rows: [Row], tag: String = UUID().uuidString) {
        self.title = title
        self.rows = rows
        self.tag = tag
    }
}

extension Section: Equatable {
    
    public static func ==(lhs: Section, rhs: Section) -> Bool {
        return lhs.tag == rhs.tag
    }
}

extension Section: Collection {
    
    public typealias Element = Row
    public typealias Index = Int
    
    public var count: Int {
        return rows.count
    }
    
    public var startIndex: Int {
        return rows.startIndex
    }
    
    public var endIndex: Int {
        return rows.endIndex
    }
    
    public func index(after i: Int) -> Int {
        return rows.index(after: i)
    }
    
    public subscript(position: Int) -> Row {
        return rows[position]
    }
    
}

extension Array where Element == Section {
    
    public subscript(indexPath: IndexPath) -> Row {
        return self[indexPath.section][indexPath.row]
    }
}
