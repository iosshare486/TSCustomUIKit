//
//  TSTestEmptyView.swift
//  TSCustomUIKit
//
//  Created by 小铭 on 2018/9/19.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

class TSTestEmptyView: UIView {
    var customBtn = UIButton.init(type: .custom)
    var onClickA : (()->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        let text = UILabel.init(frame: .zero)
        text.text = "我是空数据"
        customBtn.setTitle("点我", for: .normal)
        customBtn.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        addSubview(text)
        addSubview(customBtn)
        text.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        customBtn.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func onClick () {
        onClickA?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

class TSTestNoNetView: UIView {
    
    var reloadNet : (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let text = UILabel.init(frame: .zero)
        text.isUserInteractionEnabled = true
        text.text = "我是无网络"
        text.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(gesOnclic)))
        addSubview(text)
        text.snp.makeConstraints { (mak) in
            mak.center.equalToSuperview()
        }
    }
    
    @objc func gesOnclic () {
        reloadNet?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
