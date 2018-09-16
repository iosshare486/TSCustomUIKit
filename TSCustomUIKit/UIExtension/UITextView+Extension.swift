//
//  UITextView+Extension.swift
//  TSCustomUIKit
//
//  Created by 任鹏杰 on 2018/9/16.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

public extension TSUIKit where TU: UITextView {
    
    /**
     设置间距
     */
    public func setLineSpace(space: CGFloat) -> Void {
        
        let paraph = NSMutableParagraphStyle()
        
        paraph.lineSpacing = space
        
        let attr = [NSAttributedStringKey.paragraphStyle: paraph]
        
        self.base.attributedText = NSAttributedString.init(string: self.base.text ?? "", attributes: attr)
    }
    
    /**
     设置HTML文字
     */
    public func setHTMLText(text: String) -> Void {
        
        if let data = text.data(using: String.Encoding.unicode) {
            do {
                let attribute = try NSAttributedString(data: data, options: [.documentType:NSAttributedString.DocumentType.html], documentAttributes: nil)
                
                self.attributedText = attribute
                
            } catch {
                
                debugPrint("无法解析HTML")
            }
        }
        
    }
}
