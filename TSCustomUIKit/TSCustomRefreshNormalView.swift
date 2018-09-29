//
//  TSCustomRefreshNormalView.swift
//  TSCustomUIKit
//
//  Created by 小铭 on 2018/9/28.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit
import TSRefresh

class TSCustomRefreshNormalView: MJRefreshHeader {
    var titleLabel = UILabel()
    override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle:
                titleLabel.textColor = .red
            case .pulling:
                titleLabel.textColor = .yellow
            case .refreshing:
                titleLabel.textColor = .green
            default:
                titleLabel.textColor = .red
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        titleLabel.text = "我是下拉刷新哦"
        titleLabel.font = 15.ts.font()
        titleLabel.textColor = .red
        titleLabel.textAlignment = .center
        
        addSubview(titleLabel)
        self.mj_h = 50.ts.scale()

    }

    override func placeSubviews() {
        super.placeSubviews()
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(50.ts.scale())
        }
    }
    
}
