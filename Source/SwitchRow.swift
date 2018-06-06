//
//  SwitchRow.swift
//  TextureForm
//
//  Created by Liu on 2018/2/27.
//  Copyright © 2018年 grace.app. All rights reserved.
//

import Foundation
import AsyncDisplayKit

open class SwitchRow: RowCellNode, FormRowType {
    
    let textNode = ASTextNode()
    let switchNode = ASDisplayNode { () -> UIView in
        return UISwitch()
    }
    
    public var isOn = false {
        didSet {
            switchView?.isOn = isOn
        }
    }
    
    public var valueDidChange: ((Bool) -> Void)?
    
    private var switchView: UISwitch? {
        if switchNode.isNodeLoaded {
            return switchNode.view as? UISwitch
        } else {
            return nil
        }
    }
    
    public init(title: String) {
        super.init()
        separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        selectionStyle = .none
        
        let attString = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17)])
        textNode.attributedText = attString
        
        addSubnode(textNode)
        addSubnode(switchNode)
        
        switchNode.backgroundColor = UIColor.clear
        switchNode.onDidLoad { [weak self] node in
            if let switchView = node.view as? UISwitch {
                self?.didLoadSwitch(switchView)
            }
        }
    }
    
    private func didLoadSwitch(_ switchView: UISwitch) {
        switchView.isOn = isOn
        switchView.addTarget(self, action: #selector(self.switchValueDidChanged), for: .valueChanged)
    }
    
    @objc private func switchValueDidChanged(_ switchView: UISwitch) {
        isOn = switchView.isOn
        valueDidChange?(isOn)
    }
    
    override open func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let flex = ASStackLayoutSpec()
        flex.style.flexGrow = 1
        
        switchNode.style.preferredSize = CGSize(width: 51, height: 31)
        
        let mainStack = ASStackLayoutSpec.horizontal()
        mainStack.alignItems = .center
        mainStack.spacing = 10
        mainStack.children = [textNode, flex, switchNode]
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 20), child: mainStack)
    }
    
    
}
