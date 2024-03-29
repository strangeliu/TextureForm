//
//  FormViewController.swift
//  MagnetMan
//
//  Created by Liu on 2017/12/29.
//  Copyright © 2017年 grace.app.MagnetMan. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import DifferenceKit

open class FormViewController: ASDKViewController<ASDisplayNode> {
    
    public var sections = [Section]()
    public let tableNode: ASTableNode
    
    public var autoDeselectRow = true
    
    public init(style: UITableView.Style = .grouped) {
        tableNode = ASTableNode(style: style)
        super.init(node: ASDisplayNode())
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        tableNode = ASTableNode(style: .grouped)
        super.init(node: ASDisplayNode())
        commonInit()
    }
    
    private func commonInit() {
        node.addSubnode(tableNode)
        tableNode.onDidLoad { [weak self] _ in
            self?.tableViewDidLoad()
        }
        tableNode.delegate = self
        tableNode.dataSource = self
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        tableNode.frame = node.bounds
        rebuildForm(force: true)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableNode.frame = node.bounds
    }
    
    private func tableViewDidLoad() {
        tableNode.view.tableFooterView = UIView()
    }
    
    open func rebuildForm(force: Bool = false) {
        reload(to: buildForm(), force: force)
    }
    
    public func reload(to sections: [Section], force: Bool = false) {
        let oldSections = self.sections
        self.sections = sections
        sections.map({$0.rows.last}).forEach { row in
            row?.separatorInset = .zero
        }
        for section in sections {
            for row in section.rows {
                if var row = row as? PresenterRowType {
                    row.formViewController = self
                }
            }
        }
        if force {
            tableNode.reloadData()
        } else {
            let changeSet = StagedChangeset(source: oldSections, target: sections)
            tableNode.reloadData(using: changeSet, interrupt: nil, setData: { [weak self] sections in
                self?.sections = sections
            }, reloadRow: nil)
        }
    }
    
    open func buildForm() -> [Section] {
        return []
    }
    
}

extension FormViewController: ASTableDelegate, ASTableDataSource {
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
#if os(tvOS)
        guard tableView.style == .grouped else {
            return nil
        }
#else
        if #available(iOS 13.0, tvOS 13.0, *) {
            guard tableView.style == .grouped || tableView.style == .insetGrouped else {
                return nil
            }
        } else {
            guard tableView.style == .grouped else {
                return nil
            }
        }
#endif
        let section = sections[section]
        return section.title
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = sections[section]
        return section.headerHeight ?? (section.title == nil ? 0 : 44)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard tableView.style == .plain else {
            return nil
        }
        let section = sections[section]
        let headerView: TitleHeaderView
        if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "titleHeader") {
            headerView = view as! TitleHeaderView
        } else {
            let view = TitleHeaderView(reuseIdentifier: "titleHeader")
            view.contentView.backgroundColor = tableView.backgroundColor
            view.backgroundColor = tableView.backgroundColor
            headerView = view
        }
        headerView.titleLabel.text = section.title ?? " "
        return headerView
    }
    
    public func numberOfSections(in tableNode: ASTableNode) -> Int {
        return sections.count
    }
    
    public func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    public func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        return sections[indexPath.section].rows[indexPath.row]
    }
    
    public func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        if autoDeselectRow {
            tableNode.deselectRow(at: indexPath, animated: true)
        }
        let row = sections[indexPath.section].rows[indexPath.row]
        row.onSelected?(row)
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let row = sections[indexPath]
        return row.editActions != nil && row.editActions?.count != 0
    }
    
#if os(tvOS)
    
    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {

    }
    
    public func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        return true
    }
    
#else
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return sections[indexPath].editActions?.map({ $0.rowAction })
    }
#endif
    
    public func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange(min: CGSize(width: tableNode.bounds.width, height: 0), max: CGSize(width: tableNode.bounds.width, height: CGFloat.greatestFiniteMagnitude / 2))
    }
}
