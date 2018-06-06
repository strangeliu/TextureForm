//
//  TitleHeaderView.swift
//  TextureForm
//
//  Created by Liu on 2018/2/27.
//  Copyright © 2018年 grace.app. All rights reserved.
//

import Foundation
import UIKit

class TitleHeaderView: UITableViewHeaderFooterView {
    
    let titleLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor(white: 0.3, alpha: 1)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 15, y: contentView.frame.height - 40, width: contentView.frame.width - 30, height: 40)
    }
    
}
