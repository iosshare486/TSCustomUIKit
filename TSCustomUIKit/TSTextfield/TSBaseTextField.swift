//
//  TSBaseTextField.swift
//  TSCustomUIKit
//
//  Created by 小铭 on 2018/9/12.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

open class TSBaseTextField: UITextField {

    open var placeholderNormalColor : UIColor?
    open var placeholderHighlightColor : UIColor?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    override open func becomeFirstResponder() -> Bool {
        if let highlightColor = placeholderNormalColor {
            self.setValue(highlightColor, forKeyPath: "_placeholderLabel.textColor")
        }
        return super.becomeFirstResponder()
    }
    
    open override func resignFirstResponder() -> Bool {
        if let normalColor = placeholderNormalColor {
            self.setValue(normalColor, forKeyPath: "_placeholderLabel.textColor")
        }
        return super.resignFirstResponder()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
