//
//  TSRegularExpression.swift
//  TSCustomUIKit
//
//  Created by 小铭 on 2018/9/12.
//  Copyright © 2018年 caiqr. All rights reserved.
//  正则集合

import UIKit

struct TSRegularExpression {
    //只有数字
    static let OnlyNumberPattern = "[0-9]"
    //只有英文
    static let OnlyEnglishPattern = "[A-Za-z]"
    //只有中文
    static let OnlyChinesePattern = "[\u{4e00}-\u{9fa5}]"
    //全部
    static let AllCharPattern = "."
    //禁止数字
    static let BanNumberPattern = "[^0-9]"
    //禁止英文
    static let BanEnglishPattern = "[^A-Za-z]"
    //禁止中文
    static let BanChinesePattern = "[^\u{4e00}-\u{9fa5}]"
    //标点符号
    static let MarkChar = "-/:;()¥&@.,?!'[]{}#%^*+=_\\|~<>$€£•'!?,.-/：；（）¥@“”.！？、，。【】｛｝#%^*+=_—\\～《》$&·'!?"
}
