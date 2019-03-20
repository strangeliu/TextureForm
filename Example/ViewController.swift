//
//  ViewController.swift
//  Example
//
//  Created by Liu on 2018/2/27.
//  Copyright © 2018年 grace.app. All rights reserved.
//

import UIKit
import TextureForm

extension Array {
    
    func shuffle() -> Array {
        return self.sorted { (_, _) -> Bool in
            return Bool.random()
        }
    }
}

class ViewController: FormViewController {
    
    let textRow = TextRow(title: "TextRow")
    let switchRow = SwitchRow(title: "SwitchRow")
    let optionsRow = ActionSheetRow<String>(title: "ActionSheet", options: ["a", "b", "c"])

    override func viewDidLoad() {
        super.viewDidLoad()
        textRow.value = "description"
        switchRow.isOn = true
        switchRow.valueDidChange = { value in
            print(value)
        }
        optionsRow.accessoryType = .disclosureIndicator
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Random", style: .plain, target: self, action: #selector(self.random))
    }
    
    @objc private func random() {
        let rows = [textRow, switchRow, optionsRow]
        reload(to: [Section(tag: "0", title: "Section", rows: rows.shuffle())], force: true)
    }

    override func buildForm() -> [Section] {
        return [Section(tag: "0", title: "Section", rows: [textRow, switchRow, optionsRow])]
    }

}

