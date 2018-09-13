//
//  TSTextFieldView.swift
//  TSCustomUIKit
//
//  Created by 小铭 on 2018/9/12.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

@objc public protocol tsTextfieldProtocol {
    //正在输入是否合法的回调
    @objc optional func eligibleStatusCallBack (textField: UITextField, status : Bool)
    
    @objc optional func tsTextFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    
    @objc optional func tsTextFieldDidBeginEditing(_ textField: UITextField)
    
    @objc optional func tsTextFieldShouldEndEditing(_ textField: UITextField) -> Bool
    
    @objc optional func tsTextFieldDidEndEditing(_ textField: UITextField)
    
    @available(iOS 10.0, *)
    @objc optional func tsTextFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason)
    
    @objc optional func tsTextFieldShouldClear(_ textField: UITextField) -> Bool
    
    @objc optional func tsTextFieldShouldReturn(_ textField: UITextField) -> Bool
}

public enum TSTextFieldLimitType {
    case tsTextFieldPhoneNumberType(insertSpace : Bool)         //手机号
    case tsTextFieldEmailType               //邮箱
    case tsTextFieldIDCardType              //身份证
    case tsTextFieldCardCodeType            //银行卡号
    case tsTextFieldWordAndNumberType(range : tsTextFieldLimitRange)            //字母与数字
    case tsTextFieldOnlyNumberType(range : tsTextFieldLimitRange) //纯数字
    case tsTextFieldCustomLimit(limit : tsTextFieldLimitRange) //自定义限制输入
}

public struct tsTextFieldLimitRange {
    public init(minNum : Int,maxNum : Int) {
        self.maxNum = maxNum < minNum ? minNum : maxNum
        self.minNum = minNum
    }
    public init(_ customLimit : @escaping (() -> Bool)) {
        self.customLimit = customLimit
    }
    public var minNum : Int?
    public var maxNum : Int?
    
    public  var customLimit : (() -> Bool)?
}

open class TSTextFieldView: UIView {
    /// 输入字体
    open var textFont : UIFont? {
        didSet {
            tsTextField.font = textFont
        }
    }
    
    /// 文字颜色
    open var textColor : UIColor? {
        didSet {
            tsTextField.textColor = textColor
        }
    }
    ///是否加密
    open var isSecureTextEntry : Bool? {
        didSet {
            tsTextField.isSecureTextEntry = isSecureTextEntry!
        }
    }
    
    ///键盘类型
    open var keyboardType : UIKeyboardType? {
        didSet {
            tsTextField.keyboardType = keyboardType!
        }
    }
    
    ///默认提示文字
    open var placeholder : String? {
        didSet{
            tsTextField.placeholder = placeholder
        }
    }
    
    ///默认光标颜色
    open var textTintColor : UIColor? {
        didSet {
            tsTextField.tintColor = textTintColor
        }
    }
    
    ///清除按钮类型
    open var textClearButtonMode : UITextFieldViewMode? {
        didSet {
            tsTextField.clearButtonMode = textClearButtonMode!
        }
    }
    
    /// 是否限制特殊符号
    open var limitMarkChar = false
    /// 是否限制表情符号
    open var limitEmoji = false
    /// 是否合法
    var isEligible = false
    
    public var tsTextfieldDelegate: tsTextfieldProtocol?
    public var limitLenght = 0
    /**
    输入框限制类型
    */
    public var limitType: TSTextFieldLimitType?
    //字符串长度
    private var strLength = 0
    //正则表达式
    private var pattern = ""
    //输入字符串
    private var allStr = ""
    
    open var tsTextField = TSBaseTextField.init(frame: .zero)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        pattern = TSRegularExpression.BanNumberPattern
        initUI()
    }
    //构建UI
    private func initUI() {
        tsTextField.autocorrectionType = .no
        tsTextField.autocapitalizationType = .none
        tsTextField.delegate = self
        tsTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        addSubview(tsTextField)
        tsTextField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        //默认配置
        textColor = .white
        //默认的输入文字大小
        textFont = 12.ts.font()
        //默认 不加密
        isSecureTextEntry = false
        //默认的提示文字 （无）
        placeholder = ""
        //默认的键盘类型 （默认键盘）
        keyboardType = .default
        //默认的清除按钮类型 (无)
        textClearButtonMode = .never
    }
    
    /// 输入内容变化
    @objc private func textFieldChanged(_ textField : TSBaseTextField) {
        if isSecureTextEntry! {
            textField.text = allStr
        }

        guard let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive) else {
            return
        }
        
        let textRange = textField.markedTextRange
        
        if textRange?.start == nil {
            let position = textField.position(from: textRange?.start ?? UITextRange.init().start, offset: 0)
            if position == nil {
                let carTest = NSPredicate(format: "SELF MATCHES %@",pattern)
                carTest.evaluate(with: textField.text)
                let result = regex.matches(in: textField.text ?? "", options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, textField.text?.count ?? 0))
                var resultString = ""
                result.forEach { (res) in
                    let tempString = textField.text?[res.range.location..<res.range.length+res.range.location]
                    resultString.append(tempString ?? "")
                }
                
                if limitLenght != 0 {
                    
                    if resultString.count >= self.strLength {
                        
                        let newStr = resultString[strLength..<resultString.count]
                        let oldStr = resultString[0..<strLength]
                        
                        let newStrL = newStr.count
                        let oldStrL = oldStr.count
                        if ((oldStrL+newStrL) <= limitLenght) {
                            textField.text = resultString
                        }else{
                            textField.text = resultString[0..<strLength]
                        }
                        strLength = textField.text?.count ?? 0
                    } else {
                        textField.text = resultString
                        strLength = textField.text?.count ?? 0
                    }
                    
                } else {
                    textField.text = resultString
                }
                
                self.tsTextfieldDelegate?.eligibleStatusCallBack?(textField: textField, status: isEligible)
            }
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TSTextFieldView {
    //判断是否有九宫格
    private func stringContainNine (_ text : String) -> Bool {
        let nineArr = ["➋","➌","➍","➎","➏","➐","➑","➒"]
        if nineArr.contains(text) {
            return true
        }
        return false
    }
    
    /// 过滤字符串中的特殊符号
    ///
    /// - Parameter text: <#text description#>
    /// - Returns: <#return value description#>
    private func stringContainsMarkChar (_ text : String) -> Bool {
        let characterSet = CharacterSet.init(charactersIn: TSRegularExpression.MarkChar).inverted
        let filtered = text.components(separatedBy: characterSet) .joined(separator: "")
        return text != filtered
    }
    
    /// 判断是否有表情
    ///
    /// - Parameter text: <#text description#>
    /// - Returns: <#return value description#>
    private func stringContainsEmoji (_ text : String) -> Bool {
        var returnValue = false
        let regex = try!NSRegularExpression.init(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: .caseInsensitive)
        
        let modifiedString = regex.stringByReplacingMatches(in: text, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange.init(location: 0, length: text.characters.count), withTemplate: "")
        returnValue = modifiedString.count == text.count
        return returnValue
    }
    
}

extension String {
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}

extension String {
    
    var length: Int {
        return self.count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)), upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}
//不包含后几个字符串的方法
extension String {
    func dropLast(_ n: Int = 1) -> String {
        return String(characters.dropLast(n))
    }
    var dropLast: String {
        return dropLast()
    }
}


extension TSTextFieldView : UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == " " {
            return false
        }
        
        if string.range(from: range) != nil {
            self.allStr = textField.text!.replacingCharacters(in: string.range(from: range)!, with: string)
        }
        
        if string == "" {
            return true
        }
        
        if stringContainNine(string) {
            return true
        }
        
        if limitMarkChar && limitEmoji {
            return stringContainsMarkChar(string) && stringContainsEmoji(string)
        } else if limitMarkChar || limitEmoji {
            if limitMarkChar {
                return stringContainsMarkChar(string)
            }
            if limitEmoji {
                return stringContainsEmoji(string)
            }
        }

        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return self.tsTextfieldDelegate?.tsTextFieldShouldBeginEditing?(textField) ?? true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.tsTextfieldDelegate?.tsTextFieldDidBeginEditing?(_:textField)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return self.tsTextfieldDelegate?.tsTextFieldShouldEndEditing?(textField) ?? true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.tsTextfieldDelegate?.tsTextFieldDidEndEditing?(textField)
    }
    
    //结束编辑
    @available(iOS 10.0, *)
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        self.tsTextfieldDelegate?.tsTextFieldDidEndEditing?(textField, reason: reason)
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return self.tsTextfieldDelegate?.tsTextFieldShouldClear?(textField) ?? true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.tsTextfieldDelegate?.tsTextFieldShouldReturn?(textField) ?? true
    }
}
