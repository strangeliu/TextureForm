//
//  LabelRow.swift
//  MagnetMan
//
//  Created by Liu on 2017/12/29.
//  Copyright © 2017年 grace.app.MagnetMan. All rights reserved.
//

import Foundation
import AsyncDisplayKit

open class TextRow: RowCellNode, FormRowType {
    
    let textNode = ASTextNode()
    let descriptionNode = ASTextNode()
    
    public var titleStyle: [NSAttributedStringKey: Any] = [.font : UIFont.systemFont(ofSize: 17)] {
        didSet {
            updateTitle()
        }
    }
    public var descriptionStyle: [NSAttributedStringKey: Any] = [.font : UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor(white: 0.5, alpha: 1)]
    
    public var text: String {
        didSet {
            updateTitle()
        }
    }
    
    public var value: String? {
        didSet {
            if let value = value {
                descriptionNode.attributedText = NSAttributedString(string: value, attributes: descriptionStyle)
            } else {
                descriptionNode.attributedText = nil
            }
        }
    }
    
    public init(title: String) {
        self.text = title
        super.init()
        
        separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        updateTitle()
        
        addSubnode(textNode)
        addSubnode(descriptionNode)
    }
    
    private func updateTitle() {
        textNode.attributedText = NSAttributedString(string: text, attributes: titleStyle)
    }
    
    override open func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        descriptionNode.style.flexShrink = 1
        textNode.style.flexShrink = 1
        let flex = ASStackLayoutSpec()
        flex.style.flexGrow = 1
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.spacing = 15
        stack.children = [textNode, flex, descriptionNode]
        let rightEdge: CGFloat = accessoryType == .none ? 20 : 0
        let insets = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: rightEdge)
        return ASInsetLayoutSpec(insets: insets, child: stack)
    }
    
}
