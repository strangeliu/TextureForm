//
//  Differ+Extension.swift
//  TextureForm
//
//  Created by Liu on 2018/3/17.
//  Copyright © 2018年 grace.app. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import DifferenceKit

extension ASTableNode {
    
    public func reload<Model>(using stagedChangeset: StagedChangeset<[Model]>, interrupt: ((Changeset<[Model]>) -> Bool)? = nil, setData: ([Model]) -> Void, reloadRow: ((ASTableNode, IndexPath, Model) -> Void)? = nil) {
        if case .none = view.window, let data = stagedChangeset.last?.data {
            setData(data)
            return reloadData()
        }
        
        for changeset in stagedChangeset {
            if let interrupt = interrupt, interrupt(changeset), let data = stagedChangeset.last?.data {
                setData(data)
                return reloadData()
            }
            setData(changeset.data)
            performBatchUpdates({ [weak self] in
                guard let `self` = self else { return }
                if !changeset.sectionDeleted.isEmpty {
                    deleteSections(IndexSet(changeset.sectionDeleted), with: .automatic)
                }
                
                if !changeset.sectionInserted.isEmpty {
                    insertSections(IndexSet(changeset.sectionInserted), with: .automatic)
                }
                
                if !changeset.sectionUpdated.isEmpty {
                    reloadSections(IndexSet(changeset.sectionUpdated), with: .automatic)
                }
                
                for (source, target) in changeset.sectionMoved {
                    moveSection(source, toSection: target)
                }
                
                if !changeset.elementDeleted.isEmpty {
                    deleteRows(at: changeset.elementDeleted.map { IndexPath(row: $0.element, section: $0.section) }, with: .automatic)
                }
                
                if !changeset.elementInserted.isEmpty {
                    insertRows(at: changeset.elementInserted.map { IndexPath(row: $0.element, section: $0.section) }, with: .automatic)
                }
                
                if !changeset.elementUpdated.isEmpty {
                    changeset.elementUpdated.forEach({
                        let indexPath = IndexPath(row: $0.element, section: $0.section)
                        reloadRow?(self, indexPath, changeset.data[$0.element])
                    })
                }
                
                for (source, target) in changeset.elementMoved {
                    moveRow(at: IndexPath(row: source.element, section: source.section), to: IndexPath(row: target.element, section: target.section))
                }
            }) { _ in
                
            }
        }
    }
    
    func reloadSections<DifferentiableSectionType: DifferentiableSection>(using stagedChangeset: StagedChangeset<[DifferentiableSectionType]>, interrupt: ((Changeset<[DifferentiableSectionType]>) -> Bool)? = nil, setData: ([DifferentiableSectionType]) -> Void, reloadRow: ((ASTableNode, IndexPath) -> Void)? = nil) where DifferentiableSectionType.Collection.Index == Int {
        if case .none = view.window, let data = stagedChangeset.last?.data {
            setData(data)
            return reloadData()
        }
        
        for changeset in stagedChangeset {
            if let interrupt = interrupt, interrupt(changeset), let data = stagedChangeset.last?.data {
                setData(data)
                return reloadData()
            }
            setData(changeset.data)
            performBatchUpdates({ [weak self] in
                guard let `self` = self else { return }
                if !changeset.sectionDeleted.isEmpty {
                    deleteSections(IndexSet(changeset.sectionDeleted), with: .automatic)
                }
                
                if !changeset.sectionInserted.isEmpty {
                    insertSections(IndexSet(changeset.sectionInserted), with: .automatic)
                }
                
                if !changeset.sectionUpdated.isEmpty {
                    reloadSections(IndexSet(changeset.sectionUpdated), with: .automatic)
                }
                
                for (source, target) in changeset.sectionMoved {
                    moveSection(source, toSection: target)
                }
                
                if !changeset.elementDeleted.isEmpty {
                    deleteRows(at: changeset.elementDeleted.map { IndexPath(row: $0.element, section: $0.section) }, with: .automatic)
                }
                
                if !changeset.elementInserted.isEmpty {
                    insertRows(at: changeset.elementInserted.map { IndexPath(row: $0.element, section: $0.section) }, with: .automatic)
                }
                
                if !changeset.elementUpdated.isEmpty {
                    changeset.elementUpdated.forEach({
                        let indexPath = IndexPath(row: $0.element, section: $0.section)
                        reloadRow?(self, indexPath)
                    })
                }
                
                for (source, target) in changeset.elementMoved {
                    moveRow(at: IndexPath(row: source.element, section: source.section), to: IndexPath(row: target.element, section: target.section))
                }
            }) { _ in
                
            }
        }
    }
}
