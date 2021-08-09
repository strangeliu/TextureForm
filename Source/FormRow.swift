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

@objc(FormContextualAction)
open class ContextualAction: NSObject {

    open var style: ContextualAction.Style

    open var handler: ContextualAction.Handler

    
    open var title: String?

    open var backgroundColor: UIColor?

    open var image: UIImage?
    
    public init(style: ContextualAction.Style, title: String?, handler: @escaping ContextualAction.Handler) {
        self.style = style
        self.title = title
        self.handler = handler
    }
}

extension ContextualAction {
    
    public typealias Handler = (ContextualAction, IndexPath, UIView?, ((Bool) -> Void)?) -> Void

    public enum Style : Int {

        case normal
        case destructive
    }
}

extension ContextualAction {
    
    var rowAction: UITableViewRowAction {
        let handler = self.handler
        return UITableViewRowAction(style: style.rowStyle, title: title) { [weak self] (rowAction, indexPath) in
            if let self = self {
                handler(self, indexPath, nil, nil)
            }
        }
    }
}

extension ContextualAction.Style {
    
    var rowStyle: UITableViewRowAction.Style {
        switch self {
        case .normal:
            return .normal
        case .destructive:
            return .destructive
        }
    }
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
        get {
            return super.backgroundColor
        }
        set {
            super.backgroundColor = newValue
            if ignoreSetBackgroundColor {
                ignoreSetBackgroundColor = false
            } else {
                restoreBackgroundColor = newValue
            }
        }
    }
    
    private lazy var restoreBackgroundColor = self.backgroundColor
    
    private var ignoreSetBackgroundColor = false
    
    override open var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            super.isHighlighted = newValue
            if #available(iOS 13.0, *) {
                if newValue {
                    restoreBackgroundColor = backgroundColor
                }
                ignoreSetBackgroundColor = true
                if newValue {
                    backgroundColor = .clear
                } else {
                    UIView.animate(withDuration: 0.5, delay: 0.15, options: [], animations: {
                        self.backgroundColor = self.restoreBackgroundColor
                    })
                }
            }
        }
    }
    
    let tag: String?
    
    public var editActions: [ContextualAction]?
    
    public var onSelected: ((Row) -> Void)?
    
    public init(tag: String? = nil) {
        self.tag = tag
        super.init()
        backgroundColor = UIColor.white
    }
}

extension RowCellNode: Differentiable {
    
    public var differenceIdentifier: Int {
        return tag?.hashValue ?? ObjectIdentifier(self).hashValue
    }
    
    public func isContentEqual(to source: RowCellNode) -> Bool {
        return true
    }
}
