//
//  OptionsViewController.swift
//  TextureForm
//
//  Created by Liu on 2018/8/15.
//  Copyright © 2018年 grace.app. All rights reserved.
//

import Foundation
import AsyncDisplayKit

public protocol OptionType: Equatable, CustomStringConvertible {}

open class OptionsViewController<Option: OptionType>: FormViewController {
    
    private(set) var options: [Option]
    
    var selectedOption: Option?
    public var onSelectOption: ((Option) -> Void)?
    
    private let optionRows: [TextRow]
    
    public init(options: [Option], selected: Option? = nil) {
        self.options = options
        self.selectedOption = selected
        let optionRows = options.map({ option -> TextRow in
            let row = TextRow(title: option.description)
            row.accessoryType = option == selected ? .checkmark : .none
            return row
        })
        self.optionRows = optionRows
        super.init()
        
        for (index, row) in optionRows.enumerated() {
            row.onSelected = { [weak self] row in
                row.accessoryType = .checkmark
                let option = options[index]
                self?.onSelectOption?(option)
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func buildForm() -> [Section] {
        return [Section(rows: optionRows)]
    }
}

