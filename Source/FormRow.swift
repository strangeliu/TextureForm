//
//  FormRow.swift
//  MagnetMan
//
//  Created by Liu on 2017/12/29.
//  Copyright © 2017年 grace.app.MagnetMan. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import DifferenceKit

public typealias Row = RowCellNode

public protocol PresenterRowType {
    
    var formViewController: FormViewController? { get set }
}

open class RowCellNode: ASCellNode {
    
    let tag: String
    
    public var editActions: [UITableViewRowAction]?
    
    public var onSelected: ((Row) -> Void)?
    
    public init(tag: String = UUID().uuidString) {
        self.tag = tag
        super.init()
        backgroundColor = UIColor.white
    }
}

extension RowCellNode: Differentiable {
    
    public var differenceIdentifier: String {
        return tag
    }
    
    public func isContentEqual(to source: RowCellNode) -> Bool {
        return true
    }
}
