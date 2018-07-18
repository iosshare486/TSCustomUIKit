//
//  UILabel+Extension.swift
//  iOSQuizzes
//
//  Created by 任鹏杰 on 2018/1/3.
//  Copyright © 2018年 任鹏杰. All rights reserved.
//

import UIKit

public extension UILabel {
        
    convenience public init(text: String?,
                     textColor: UIColor?,
                     textFont: UIFont?){
        
        self.init()
        
        self.text = text
        
        if let color = textColor {
            
            self.textColor = color
        }
        
        if let font = textFont {
            
            self.font = font
        }
    }
}


public extension TSUIKit where TU: UILabel {
    
    public func setLineSpace(space: CGFloat) -> Void {
        
        let paraph = NSMutableParagraphStyle()
        
        paraph.lineSpacing = space
        
        let attr = [NSAttributedStringKey.paragraphStyle: paraph]
        
        self.base.attributedText = NSAttributedString.init(string: self.base.text ?? "", attributes: attr)
    }
    
}

