//
//  Differ+Extension.swift
//  TextureForm
//
//  Created by Liu on 2018/3/17.
//  Copyright © 2018年 grace.app. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import Differ

public struct NestedBatchUpdate {
    let itemDeletions: [IndexPath]
    let itemInsertions: [IndexPath]
    let itemMoves: [(from: IndexPath, to: IndexPath)]
    let sectionDeletions: IndexSet
    let sectionInsertions: IndexSet
    let sectionMoves: [(from: Int, to: Int)]
    
    init(
        diff: NestedExtendedDiff,
        indexPathTransform: (IndexPath) -> IndexPath = { $0 },
        sectionTransform: (Int) -> Int = { $0 }
        ) {
        
        var itemDeletions: [IndexPath] = []
        var itemInsertions: [IndexPath] = []
        var itemMoves: [(IndexPath, IndexPath)] = []
        var sectionDeletions: IndexSet = []
        var sectionInsertions: IndexSet = []
        var sectionMoves: [(from: Int, to: Int)] = []
        
        diff.forEach { element in
            switch element {
            case let .deleteElement(at, section):
                itemDeletions.append(indexPathTransform(IndexPath(item: at, section: section)))
            case let .insertElement(at, section):
                itemInsertions.append(indexPathTransform(IndexPath(item: at, section: section)))
            case let .moveElement(from, to):
                itemMoves.append((indexPathTransform(IndexPath(item: from.item, section: from.section)), indexPathTransform(IndexPath(item: to.item, section: to.section))))
            case let .deleteSection(at):
                sectionDeletions.insert(sectionTransform(at))
            case let .insertSection(at):
                sectionInsertions.insert(sectionTransform(at))
            case let .moveSection(move):
                sectionMoves.append((sectionTransform(move.from), sectionTransform(move.to)))
            }
        }
        
        self.itemInsertions = itemInsertions
        self.itemDeletions = itemDeletions
        self.itemMoves = itemMoves
        self.sectionMoves = sectionMoves
        self.sectionInsertions = sectionInsertions
        self.sectionDeletions = sectionDeletions
    }
}

extension ASTableNode {
    
    public func apply(
        _ diff: NestedExtendedDiff,
        indexPathTransform: @escaping (IndexPath) -> IndexPath = { $0 },
        sectionTransform: @escaping (Int) -> Int = { $0 },
        completion: ((Bool) -> Void)? = nil
        ) {
        performBatchUpdates({
            let update = NestedBatchUpdate(diff: diff, indexPathTransform: indexPathTransform, sectionTransform: sectionTransform)
            self.insertSections(update.sectionInsertions, with: .automatic)
            self.deleteSections(update.sectionDeletions, with: .automatic)
            update.sectionMoves.forEach { self.moveSection($0.from, toSection: $0.to) }
            self.deleteRows(at: update.itemDeletions, with: .automatic)
            self.insertRows(at: update.itemInsertions, with: .automatic)
            update.itemMoves.forEach { self.moveRow(at: $0.from, to: $0.to) }
        }, completion: completion)
    }
}

