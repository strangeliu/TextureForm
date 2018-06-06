//
//  FormRow.swift
//  MagnetMan
//
//  Created by Liu on 2017/12/29.
//  Copyright © 2017年 grace.app.MagnetMan. All rights reserved.
//

import Foundation
import AsyncDisplayKit

public typealias Row = RowCellNode & FormRowType

public protocol FormRowType {
    
    var actions: [UITableViewRowAction]? { get }
    
    var tag: String? { get }
}

public protocol PresenterRowType {
    
    var formViewController: FormViewController? { get set }
}

extension FormRowType {
    
    public var actions: [UITableViewRowAction]? {
        return nil
    }
    
    public var tag: String? {
        return nil
    }
}

open class RowCellNode: ASCellNode {
    
    public var onSelected: ((Row) -> Void)?
    
    public override init() {
        super.init()
        backgroundColor = UIColor.white
    }
    
    
}
