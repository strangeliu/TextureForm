//
//  MenuRow.swift
//  MagnetMan
//
//  Created by Liu on 2017/12/29.
//  Copyright © 2017年 grace.app.MagnetMan. All rights reserved.
//

import Foundation
import AsyncDisplayKit

open class MenuRow: RowCellNode, FormRowType {
    
    public let imageNode = ASImageNode()
    public let textNode = ASTextNode()
    
    public init(title: String, image: UIImage?) {
        super.init()
        
        addSubnode(imageNode)
        addSubnode(textNode)
        
        let attString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)])
        textNode.attributedText = attString
        imageNode.image = image
        
        separatorInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 0)
    }
    
    public func update(text: String) {
        textNode.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)])
    }
    
    override open func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.spacing = 15
        stack.children = [imageNode, textNode]
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 20), child: stack)
    }
    
}
