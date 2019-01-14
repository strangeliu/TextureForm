//
//  WrapRow.swift
//  TextureForm
//
//  Created by Liu on 2018/12/17.
//  Copyright © 2018 grace.app. All rights reserved.
//

import Foundation
import AsyncDisplayKit

open class WrapRow<NodeType: ASDisplayNode>: RowCellNode, FormRowType {
    
    public let contentNode: NodeType
    public let descriptionNode = ASTextNode()
    public let insets: UIEdgeInsets
    
    public init(contentNode: NodeType, insets: UIEdgeInsets) {
        self.contentNode = contentNode
        self.insets = insets
        super.init()
        separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        addSubnode(contentNode)
    }
    
    override open func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: insets, child: contentNode)
    }
    
}
