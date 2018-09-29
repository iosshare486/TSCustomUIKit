//
//  TSNoNetWorkNormalView.swift
//  TSCustomUIKit
//
//  Created by 小铭 on 2018/9/20.
//  Copyright © 2018年 caiqr. All rights reserved.
// 默认无网络展位图

import UIKit
import SnapKit
import TSUtility

open class TSNoNetWorkNormalView: UIView {
    public var noNetIMG = UIImageView()
    public var noNetBtn = UIButton.init(type: .custom)
    public var noNetAction : (()->())?
    public init(_ Img : UIImage , _ reloadText : String , _ noNetAction : (()->())?) {
        super.init(frame: .zero)
        creatSubS()
        self.noNetAction = noNetAction
        noNetIMG.image = Img
        noNetBtn.setTitle(reloadText, for: .normal)
        addSubS()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        creatSubS()
        addSubS()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubS () {
        addSubview(noNetIMG)
        addSubview(noNetBtn)
        noNetIMG.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        noNetBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(noNetIMG.snp.bottom).offset(10.ts.scale())
            make.width.equalTo(120.ts.scale())
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.height.equalTo(40.ts.scale())
        }
    }
    
    private func creatSubS () {
        noNetIMG.contentMode = .scaleAspectFit
        
        noNetBtn.setTitle("点击刷新", for: .normal)
        noNetBtn.setTitleColor(0x5cc3ff.ts.color(), for: .normal)
        noNetBtn.titleLabel?.font = 15.ts.font()
        noNetBtn.layer.cornerRadius = 40.ts.scale() / 2
        noNetBtn.layer.masksToBounds = true
        noNetBtn.layer.borderWidth = 1
        noNetBtn.layer.borderColor = 0x5cc3ff.ts.color().cgColor
        noNetBtn.addTarget(self, action: #selector(noNetOnClick), for: .touchUpInside)
    }
    
    @objc private func noNetOnClick () {
        noNetAction?()
    }
    
}
