//
//  ViewController.swift
//  Example
//
//  Created by Liu on 2018/2/27.
//  Copyright © 2018年 grace.app. All rights reserved.
//

import UIKit
import TextureForm

class ViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func buildForm() -> [Section] {
        let textRow = TextRow(title: "TextRow")
        textRow.value = "description"
        let switchRow = SwitchRow(title: "SwitchRow")
        switchRow.isOn = true
        switchRow.valueDidChange = { value in
            print(value)
        }
        let optionsRow = ActionSheetRow<String>(title: "ActionSheet", options: ["a", "b", "c"])
        optionsRow.accessoryType = .disclosureIndicator
        return [Section(title: "Section", rows: [textRow, switchRow, optionsRow])]
    }

}

