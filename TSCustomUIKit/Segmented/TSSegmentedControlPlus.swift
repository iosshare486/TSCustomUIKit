//
//  TSSegmentedControlPlus.swift
//  TSCustomUIKit
//
//  Created by huangyuchen on 2018/10/17.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit
import TSUtility
import SnapKit

/// 对齐方式
public enum TSSegmentedControlPlusAlignment {
    case left, right, center
}
/// 每个segmentedItem的配置信息
@objc public class TSSegmentedControlPlusTitleItem: NSObject {
    /// 普通文字
    public var normalTitle: String?
    /// 选中文字
    public var selectTitle: String?
    /// 文字 普通时颜色
    public var normalColor: UIColor? = 0x9.ts.color()
    /// 文字 选中时颜色
    public var selectColor: UIColor? = 0xff5050.ts.color()
    /// 文字 普通时大小
    public var normalFont: UIFont? = 15.ts.font()
    /// 文字 选中时大小
    public var selectFont: UIFont? = 15.ts.font()
    /// 普通图片
    public var normalImage: UIImage?
    /// 选中图片
    public var selectImage: UIImage?
    /// 普通背景图片
    public var normalBackgroundImage: UIImage?
    /// 选中背景图片
    public var selectBackgroundImage: UIImage?
}

@objc public protocol TSSegmentedControlPlusDelegate : class {
    
    /// 选中的位置
    ///
    /// - Parameter index: 选中的下标
    @objc optional func segmentedControlPlusSelectIndex(index: Int)
}

@objc public protocol TSSegmentedControlPlusDataSource {
    
    /// item大小
    ///
    /// - Parameter index: 位置下标
    /// - Returns: size
    @objc optional func segmentedControlPlusItemSize(index: Int) -> CGSize
    
    /// 间距
    ///
    /// - Parameter index: 位置下标
    /// - Returns: 间距
    @objc optional func segmentedControlPlusItemSpace(index: Int) -> CGFloat
    
}

public class TSSegmentedControlPlus: UIView {
    
//MARK: - public属性
    /// 底部线的颜色
    public var bottomLineColor: UIColor = 0xf5.ts.color()
    /// 滑动线的宽度
    public var scrollLineWidth: CGFloat = 75.ts.scale()
    /// 滑动线的高度
    public var scrollLineHeight: CGFloat = 3.ts.scale()
    /// 滑动线与底部的距离
    public var scrollLineBottomY: CGFloat = 0
    /// 滑动线颜色
    public var scrollLineColor: UIColor = 0xff5050.ts.color()
    /// 距离左侧的间距
    public var leftSpace: CGFloat = 0
    /// 距离右侧的间距
    public var rightSpace: CGFloat = 0
    /// 选中按钮的回调代理
    public weak var delegate: TSSegmentedControlPlusDelegate?
    /// segmented 配置资源
    public weak var dataSource: TSSegmentedControlPlusDataSource?
    /// 对齐方式 默认距左
    public var alignment: TSSegmentedControlPlusAlignment = .left
    
//MARK: - private属性
    private lazy var mainScorllView: UIScrollView = UIScrollView(frame: .zero)
    
    private lazy var mainView: UIView = UIView(frame: .zero)
    
    private lazy var scrollLine: UIView = UIView()
    
    private lazy var bottomLine: UIView = UIView()
    
    private lazy var buttonArray: [UIButton] = [UIButton]()
    
    private lazy var buttonTitle: [TSSegmentedControlPlusTitleItem] = [TSSegmentedControlPlusTitleItem]()
    
//MARK: - Override
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }

    public override func layoutSubviews() {
        
        super.layoutSubviews()
        self.layoutIfNeeded()
        
        /// 如果mainView的宽度小于scrollview的宽度，则需要根据对齐方式来确定位置
        if mainView.frame.width < mainScorllView.frame.width {
            
            mainView.snp.remakeConstraints { (make) in
                
                if self.alignment == .left {
                    make.left.equalTo(self)
                }else if self.alignment == .center {
                    make.centerX.equalTo(self)
                }else {
                    make.right.equalTo(self)
                }
                make.top.equalToSuperview()
                make.height.equalToSuperview()
            }
        }else {
            mainView.snp.remakeConstraints { (make) in
                
                make.left.equalToSuperview()
                make.top.equalToSuperview()
                make.height.equalToSuperview()
            }
        }
        
        mainScorllView.contentSize = mainView.frame.size
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - public method
    /// 快捷创建方式（使用该方式创建，可以不使用segmentedControlSetConfigItem这个协议）
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - titleArray: titles
    public convenience init(frame: CGRect, titleArray: Array<TSSegmentedControlPlusTitleItem>){
        
        self.init(frame: frame)
        self.buttonTitle.removeAll()
        self.buttonTitle.append(contentsOf: titleArray)
        self.segmentControlInstall()
    }
    
    /// 配置好configItem后，调用该方法安装segment
    public func segmentControlInstall() {
        
        for subview in self.mainView.subviews {
            subview.removeFromSuperview()
        }
        self.buttonArray.removeAll()
    
        createUI()
        createButtons()
        setConstraints()
    }
    /// 刷新配置项
    public func segmentControlReload(titleArray: Array<TSSegmentedControlPlusTitleItem>) {
        
        self.buttonTitle.removeAll()
        self.buttonTitle.append(contentsOf: titleArray)
        self.segmentControlInstall()
    }
    /// 改变选中项
    ///
    /// - Parameter tag: 位置下标
    public func changeSelectButton(index: Int) {
        
        if index < buttonArray.count {
            selectButton(btn: buttonArray[index])
        }else {
            TSLog("TSSegmentedControl: index is not valid")
        }
        
    }
    
    /// 配置默认选中项
    ///
    /// - Parameter tag: 下标
    public func defaultSeletButton(withTag tag: Int) {
        
        guard tag < buttonArray.count else {
            
            TSLog("TSSegmentedControl: default index is not valid")
            return
        }
        
        buttonArray[tag].isSelected = true
        selectButton(btn: buttonArray[tag], animation: false)
    }
    
//MARK: - Event response
    
    /// 点击选中项
    ///
    /// - Parameter btn: 选中项下标
    @objc private func buttonOnClick(btn: UIButton){
        
        selectButton(btn: btn)
        
        delegate?.segmentedControlPlusSelectIndex?(index: btn.tag)
    }
    
//MARK: - Private method
    
    /// 创建基础UI
    private func createUI() {
        
        scrollLine.backgroundColor = self.scrollLineColor
        bottomLine.backgroundColor = self.bottomLineColor
        addSubview(mainScorllView)
        addSubview(bottomLine)
        mainScorllView.addSubview(mainView)
        mainView.addSubview(scrollLine)
        mainScorllView.showsVerticalScrollIndicator = false
        mainScorllView.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            mainScorllView.contentInsetAdjustmentBehavior = .never
        } else {
            /// 这里拿不到vc所以无法配置vc的属性: automaticallyAdjustsScrollViewInsets
            TSLog("TSSegmentedControlPlus：如果是iOS 11.0 请配置vc.automaticallyAdjustsScrollViewInsets = false")
        }
    }
    
    /// 配置约束
    private func setConstraints() {
        
        mainScorllView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        mainView.snp.makeConstraints { (make) in
            
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview()
        }
        if self.buttonArray.count > 0 {
            
            scrollLine.snp.makeConstraints { (make) in
                
                make.bottom.equalToSuperview().offset(-self.scrollLineBottomY)
                make.centerX.equalTo(buttonArray[0])
                make.width.equalTo(self.scrollLineWidth)
                make.height.equalTo(self.scrollLineHeight)
            }
        }
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    /// 创建每一项
    private func createButtons() {
        
        var tmpButton : UIButton?
        var count: Float = Float(self.buttonArray.count)
        
        if count > 3 {
            count = 3.0
        }
        
        for (i, title) in self.buttonTitle.enumerated(){
            
            let button : UIButton = TSSegmentedControlItemButton()

            if let normalTitle = title.normalTitle {
                button.setTitle(normalTitle, for: UIControl.State.normal)
            }
            if let selectTitle = title.selectTitle {
                button.setTitle(selectTitle, for: UIControl.State.selected)
            }
            if let normalColor = title.normalColor {
                button.setTitleColor(normalColor, for: .normal)
            }
            if let selectColor = title.selectColor {
                button.setTitleColor(selectColor, for: .selected)
            }
            if let normalImage = title.normalImage {
                button.setImage(normalImage, for: UIControl.State.normal)
            }
            if let selectImage = title.selectImage {
                button.setImage(selectImage, for: UIControl.State.selected)
            }
            if let normalBackImage = title.normalBackgroundImage {
                button.setBackgroundImage(normalBackImage, for: UIControl.State.normal)
            }
            if let selectBackImage = title.selectBackgroundImage {
                button.setBackgroundImage(selectBackImage, for: UIControl.State.selected)
            }
            button.titleLabel?.font = title.normalFont
            button.adjustsImageWhenHighlighted = false
            button.tag = i
            button.addTarget(self, action: #selector(buttonOnClick(btn:)), for: .touchUpInside)
            mainView.addSubview(button)
            
            var itemSpace: CGFloat = 0
            if let space = self.dataSource?.segmentedControlPlusItemSpace?(index: i) {
                itemSpace = space
            }
            
            button.snp.makeConstraints({ (make) in
                
                if tmpButton != nil{
                    
                    make.left.equalTo(tmpButton!.snp.right).offset(itemSpace)
                    
                }else{
                    
                    make.left.equalToSuperview().offset(leftSpace)
                }
                if let size = self.dataSource?.segmentedControlPlusItemSize?(index: i) {
                    
                    make.centerY.equalToSuperview()
                    make.width.equalTo(size.width)
                    make.height.equalTo(size.height)
                }else {
                    make.top.bottom.equalToSuperview()
                }
            })
            tmpButton = button
            buttonArray.append(button)
        }
        tmpButton?.snp.makeConstraints({ (make) in
            
            make.right.equalToSuperview().offset(rightSpace)
        })
    }
    
    private func selectButton(btn:UIButton, animation: Bool = true) {
        
        for tempButton in buttonArray {
            
            if tempButton != btn {
                tempButton.isSelected = false
                
                if let font = self.buttonTitle[tempButton.tag].normalFont {
                    tempButton.titleLabel?.font = font
                }
                
            }else{
                btn.isSelected = true
                if let font = self.buttonTitle[tempButton.tag].selectFont {
                    btn.titleLabel?.font = font
                }
            }
            self.layoutIfNeeded()
        }
        
        scrollLine.snp.remakeConstraints { (make) in
            
            make.bottom.equalToSuperview().offset(-self.scrollLineBottomY)
            make.centerX.equalTo(btn)
            make.width.equalTo(self.scrollLineWidth)
            make.height.equalTo(self.scrollLineHeight)
        }
        
        if animation {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
        let index = btn.tag
        var rightItemspace:CGFloat = 0
        if index == self.buttonArray.count {
            
            rightItemspace = self.rightSpace
        }else {
            
            rightItemspace = self.dataSource?.segmentedControlPlusItemSpace?(index: index) ?? 0
            rightItemspace = rightItemspace / 2.0
        }
        
        var leftItemspace:CGFloat = 0
        if index == 0 {
            
            leftItemspace = self.leftSpace
        }else {
            
            leftItemspace = self.dataSource?.segmentedControlPlusItemSpace?(index: index) ?? 0
            leftItemspace = leftItemspace / 2.0
        }
        
        if ((btn.frame.maxX + rightItemspace - self.frame.width) > mainScorllView.contentOffset.x){
            
            mainScorllView.setContentOffset(CGPoint(x: (btn.frame.maxX + rightItemspace - self.frame.width), y: 0), animated: true)
        }else if (mainScorllView.contentOffset.x > (btn.frame.minX - leftItemspace)) {
            
            mainScorllView.setContentOffset(CGPoint(x: btn.frame.minX - leftItemspace, y: 0), animated: true)
        }
    }
    
}

/// 为了取消按钮的高亮状态 重写isHighlighted属性
fileprivate class TSSegmentedControlItemButton: UIButton {
    
    override var isHighlighted: Bool {
        set {
            
        }
        get {
            return false
        }
    }
    
}
