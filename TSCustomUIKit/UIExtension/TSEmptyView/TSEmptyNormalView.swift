//
//  TSEmptyNormalView.swift
//  TSCustomUIKit
//
//  Created by 小铭 on 2018/9/20.
//  Copyright © 2018年 caiqr. All rights reserved.
//  空数默认View

import UIKit
import SnapKit
import TSUtility

open class TSEmptyNormalView: UIView {
    
    public var emptyLabel = UILabel.init()
    public var emptyIMG = UIImageView()
    
    public init(_ img : UIImage, _ text : String? = "") {
        super.init(frame: .zero)
        creatSubS()
        emptyIMG.image = img
        emptyLabel.text = text
        addSubS()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        creatSubS()
        addSubS()
    }
   
    private func creatSubS () {
        
        emptyIMG.contentMode = .scaleAspectFit
        emptyLabel.font = 15.ts.font()
        emptyLabel.textColor = 0x3.ts.color()
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        emptyLabel.text = "暂无数据"
    }
    
    private func addSubS () {
        addSubview(emptyIMG)
        addSubview(emptyLabel)
        
        emptyIMG.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.left.right.equalToSuperview()
        }
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyIMG.snp.bottom)
            $0.left.right.equalTo(emptyIMG)
            $0.bottom.equalToSuperview()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
