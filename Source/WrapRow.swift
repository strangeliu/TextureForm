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
    
    let contentNode: NodeType
    let descriptionNode = ASTextNode()
    
    public init(contentNode: NodeType) {
        self.contentNode = contentNode
        super.init()
        separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        addSubnode(contentNode)
    }
    
    override open func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: contentNode)
    }
    
}
