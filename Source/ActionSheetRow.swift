//
//  ActionSheetRow.swift
//  TextureForm
//
//  Created by Liu on 2018/4/8.
//  Copyright © 2018年 grace.app. All rights reserved.
//

import Foundation
import AsyncDisplayKit

open class ActionSheetRow<Option: Equatable & CustomStringConvertible>: RowCellNode, FormRowType, PresenterRowType {
    
    public weak var formViewController: FormViewController?
    
    public var selectorTitle: String?
    public var cancelTitle = "Cancel"
    public var value: Option? {
        didSet {
            if let value = value {
                descriptionNode.attributedText = NSAttributedString(string: value.description, attributes: descriptionStyle)
            } else {
                descriptionNode.attributedText = nil
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    public var titleStyle: [NSAttributedStringKey: Any] = [.font : UIFont.systemFont(ofSize: 17)]
    public var descriptionStyle: [NSAttributedStringKey: Any] = [.font : UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor(white: 0.5, alpha: 1)]
    
    public var valueDidChange: ((Option) -> Void)?
    
    let textNode = ASTextNode()
    let descriptionNode = ASTextNode()
    
    let options: [Option]
    
    public init(title: String, options: [Option]) {
        self.options = options
        super.init()
        separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        let attString = NSAttributedString(string: title, attributes: titleStyle)
        textNode.attributedText = attString
        
        addSubnode(textNode)
        addSubnode(descriptionNode)
    }
    
    open override func didLoad() {
        super.didLoad()
        onSelected = { [weak self] _ in
            self?.didSelected()
        }
    }
    
    override open func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        descriptionNode.style.flexShrink = 1
        let flex = ASStackLayoutSpec()
        flex.style.flexGrow = 1
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.spacing = 15
        stack.children = [textNode, flex, descriptionNode]
        let rightEdge: CGFloat = accessoryType == .none ? 20 : 0
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 20, left: 15, bottom: 20, right: rightEdge), child: stack)
    }
    
    private func didSelected() {
        guard let controller = formViewController else {
            return
        }
        let alertController = UIAlertController(title: nil, message: selectorTitle, preferredStyle: .actionSheet)
        for option in options {
            let action = UIAlertAction(title: option.description, style: .default) { [weak self] _ in
                self?.didSelected(option: option)
            }
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction.init(title: cancelTitle, style: .cancel, handler: nil))
        controller.present(alertController, animated: true, completion: nil)
    }
    
    private func didSelected(option: Option) {
        value = option
        valueDidChange?(option)
    }
    
}
