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
    
    private var _selectedBackgroundView: UIView?
        
    override open var selectedBackgroundView: UIView? {
        get {
            if _selectedBackgroundView == nil {
                _selectedBackgroundView = UIView()
                _selectedBackgroundView?.backgroundColor = selectedColor
            }
            return _selectedBackgroundView
        }
        set {
            _selectedBackgroundView = newValue
        }
    }
    
    public var selectedColor: UIColor? {
        didSet {
            _selectedBackgroundView?.backgroundColor = selectedColor
        }
    }
    
    override open var backgroundColor: UIColor? {
        didSet {
            originBackgroundColor = backgroundColor
        }
    }
    
    private var originBackgroundColor: UIColor?
    
    override open var isHighlighted: Bool {
        didSet {
            if #available(iOS 13.0, *) {
                backgroundColor = isHighlighted ? .clear : originBackgroundColor
            }
        }
    }
    
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
