//
//  FormViewController.swift
//  MagnetMan
//
//  Created by Liu on 2017/12/29.
//  Copyright © 2017年 grace.app.MagnetMan. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import Differ

open class FormViewController: ASViewController<ASTableNode> {
    
    public var sections = [Section]()
    let tableNode: ASTableNode
    
    public init(style: UITableView.Style = .grouped) {
        tableNode = ASTableNode(style: style)
        super.init(node: tableNode)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        tableNode = ASTableNode(style: .grouped)
        super.init(node: tableNode)
        commonInit()
    }
    
    private func commonInit() {
        tableNode.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableNode.onDidLoad { [weak self] _ in
            self?.tableViewDidLoad()
        }
        node.delegate = self
        node.dataSource = self
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        reload(force: true)
    }
    
    private func tableViewDidLoad() {
        node.view.tableFooterView = UIView()
    }
    
    open func reload(force: Bool) {
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
            node.reloadData()
        } else {
            let changes = oldSections.nestedExtendedDiff(to: sections, isEqualElement: { (l, r) -> Bool in
                return l == r
            })
            tableNode.apply(changes)
        }
    }
    
    open func buildForm() -> [Section] {
        return []
    }
    
}

extension FormViewController: ASTableDelegate, ASTableDataSource {
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard tableView.style == .grouped else {
            return nil
        }
        let section = sections[section]
        return section.title
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = sections[section]
        if tableView.style == .plain {
            if section.title == nil {
                return 0
            } else {
                return section.headerHeight ?? 44
            }
        } else {
            return section.headerHeight ?? 44
        }
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
        headerView.titleLabel.text = section.title
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
        tableNode.deselectRow(at: indexPath, animated: true)
        let row = sections[indexPath.section].rows[indexPath.row]
        row.onSelected?(row)
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let row = sections[indexPath]
        return row.editActions != nil && row.editActions?.count != 0
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return sections[indexPath].editActions
    }
    
}
