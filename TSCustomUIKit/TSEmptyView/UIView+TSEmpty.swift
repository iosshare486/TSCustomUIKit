//
//  TSEmpty+UIView.swift
//  TSCustomUIKit
//
//  Created by 小铭 on 2018/9/19.
//  Copyright © 2018年 caiqr. All rights reserved.
//  页面空数据和无网络展示

import UIKit

public extension UIView {
    //Keys
    private struct EmptyKeys {
        static var emptyStateView = "TSEmptyStateView"
        static var noNetStateView = "TSNoNetWorkStateView"
        static var stateViewScroll = "TSstateViewScroll"
    }
    
    /// 空数据View 自定义使用属性配置
    public var ts_emptyView: UIView? {
        get { return objc_getAssociatedObject(self, &EmptyKeys.emptyStateView) as? UIView }
        set {
            objc_setAssociatedObject(self, &EmptyKeys.emptyStateView, newValue, .OBJC_ASSOCIATION_RETAIN)
            if let newView = newValue {
                self.addSubview(newView)
                newView.isHidden = true
            }
        }
    }
    
    /// 无网络View
    public var ts_noNetworkView: UIView? {
        get { return objc_getAssociatedObject(self, &EmptyKeys.noNetStateView) as? UIView }
        set {
            objc_setAssociatedObject(self, &EmptyKeys.noNetStateView, newValue, .OBJC_ASSOCIATION_RETAIN)
            if let newView = newValue {
                self.addSubview(newView)
                newView.isHidden = true
            }
        }
    }
    
    //CanScroll
    public var ts_viewCanScroll: Bool? {
        get { return objc_getAssociatedObject(self, &EmptyKeys.stateViewScroll) as? Bool }
        set {
            objc_setAssociatedObject(self, &EmptyKeys.stateViewScroll, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 隐藏所有状态View
    public func ts_hiddenAllStateView () {
        if let empty = self.ts_emptyView {
            empty.isHidden = true
        }
        if let noNet = self.ts_noNetworkView {
            noNet.isHidden = true
        }
    }
    
    /// 移除所有状态View 移除后需要重新添加View
    public func ts_removeAllStateView () {
        if let empty = self.ts_emptyView {
            if self.subviews.contains(empty) {
                empty.removeFromSuperview()
            }
            self.ts_emptyView = nil
        }
        if let noNet = self.ts_noNetworkView {
            if self.subviews.contains(noNet) {
                noNet.removeFromSuperview()
            }
            self.ts_noNetworkView = nil
        }
    }
    
    /// 显示无网络页面
    public func ts_showNoNetwork() {
        if let emptyViewTemp = self.ts_emptyView {
            emptyViewTemp.isHidden = true
        }
        if let noNetView = self.ts_noNetworkView {
            if !self.subviews.contains(noNetView) {
                self.addSubview(noNetView)
                self.bringSubview(toFront: noNetView)
            }
            noNetView.isHidden = false
        } else {
            debugPrint("未设置无网络View")
        }
    }
    //ReloadStateView
    public func ts_reloadEmptyStateView() {
        if let noNetView = self.ts_noNetworkView {
            noNetView.isHidden = true
        }
        if self is UIScrollView {
            if let canScroll = self.ts_viewCanScroll {
                (self as? UIScrollView)?.isScrollEnabled = canScroll
            }
        }
        showView()
    }
    
    /// 显示无数据页面
    public func ts_showNoDataView() {
        if let noNetView = self.ts_noNetworkView {
            noNetView.isHidden = true
        }
        if self is UIScrollView {
            if let canScroll = self.ts_viewCanScroll {
                (self as? UIScrollView)?.isScrollEnabled = canScroll
            }
        }
        guard self.ts_emptyView != nil else {
            debugPrint("未设置空数据View")
            return
        }
        if let creatView = self.ts_emptyView {
            if self.subviews.contains(creatView) {
                creatView.isHidden = false
            } else {
                self.addSubview(creatView)
                creatView.isHidden = false
            }
        }
    }
    
    /// 内部显示空数据View
    private func showView () {
        guard self.ts_emptyView != nil else {
            debugPrint("未设置空数据View")
            return
        }
        if let creatView = self.ts_emptyView {
            if self.subviews.contains(creatView) {
                //TableView
                if self is UITableView {
                    creatView.isHidden = !emptyStateViewShouldShow(for: self as! UITableView)
                } else if self is UICollectionView {
                    creatView.isHidden = !emptyStateViewShouldShow(for: self as! UICollectionView)
                } else {
                    creatView.isHidden = false
                }
            } else {
                self.addSubview(creatView)
            }
        }
    }
}

// MARK: - 默认配置空数据和无网络的View
public extension UIView {
    public func tsNormalEmptyView (_ img : UIImage , _ text : String) {
        let emptyView = TSEmptyNormalView.init(img, text)
        self.ts_emptyView = emptyView
    }
    public func tsNormalNonetWorkView (_ img : UIImage , _ text : String , _ noNetAction : (()->())?) {
        let noNetView = TSNoNetWorkNormalView.init(img, text, noNetAction)
        self.ts_noNetworkView = noNetView
    }
}

extension UIView {
    /**
     Default implementation for UIViewController tableView determining if should show the emptystate view,
     counts number of rows in the tableView
     */
    private func emptyStateViewShouldShow(for tableView: UITableView) -> Bool {
        let sections = tableView.numberOfSections
        var rows = 0
        for section in 0..<sections {
            rows += tableView.numberOfRows(inSection: section)
        }
        return rows == 0
    }
    
    /**
     Default implementation for UIViewController collectionView determining if should show the emptystate view,
     counts number of items in the collectionView
     */
    private func emptyStateViewShouldShow(for collectionView: UICollectionView) -> Bool {
        let sections = collectionView.numberOfSections
        var items = 0
        for section in 0..<sections {
            items += collectionView.numberOfItems(inSection: section)
        }
        return items == 0
    }
}
