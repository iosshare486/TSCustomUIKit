//
//  TSEmpty+UIView.swift
//  TSCustomUIKit
//
//  Created by 小铭 on 2018/9/19.
//  Copyright © 2018年 caiqr. All rights reserved.
//  页面空数据和无网络展示

import UIKit
import SnapKit
import TSUtility
import TSNetworkMonitor

//Keys
private struct TSEmptyKeys {
    
    static let emptyStateView = UnsafeRawPointer.init(bitPattern: "emptyStateView".hashValue)
    static let checkToShowEmptyViewStatus = UnsafeRawPointer.init(bitPattern: "checkToShowEmptyViewStatus".hashValue)
    static let noNetStateView = UnsafeRawPointer.init(bitPattern: "noNetStateView".hashValue)
    static let stateViewScroll = UnsafeRawPointer.init(bitPattern: "stateViewScroll".hashValue)
    static let autoShowNoNetPlace = UnsafeRawPointer.init(bitPattern: "autoShowNoNetPlace".hashValue)
}

public extension TSUIKit where TU: UIView {
    
    /// 空数据View 自定义使用属性配置
    public var emptyView: UIView? {
        get { return objc_getAssociatedObject(self.base, TSEmptyKeys.emptyStateView!) as? UIView }
        set {
            objc_setAssociatedObject(self.base, TSEmptyKeys.emptyStateView!, newValue, .OBJC_ASSOCIATION_RETAIN)
            if let newView = newValue {
                self.base.addSubview(newView)
                newView.isHidden = true
            }
        }
    }
    
    /// 无网络View
    public var noNetworkView: UIView? {
        get { return objc_getAssociatedObject(self.base, TSEmptyKeys.noNetStateView!) as? UIView }
        set {
            objc_setAssociatedObject(self.base, TSEmptyKeys.noNetStateView!, newValue, .OBJC_ASSOCIATION_RETAIN)
            if let newView = newValue {
                self.base.addSubview(newView)
                newView.isHidden = true
                TSNetworkMonitor.shared.addNetworkNotification(self.base, #selector(self.base.checkNetworkChanged))
            }
        }
    }
    
    //CanScroll
    public var emptyViewCanScroll: Bool? {
        get { return objc_getAssociatedObject(self.base, TSEmptyKeys.stateViewScroll!) as? Bool }
        set {
            objc_setAssociatedObject(self.base, TSEmptyKeys.stateViewScroll!, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    ///自动显示无网络展位图 默认为自动展示
    public var autoShowOrHiddenNoNetView: Bool? {
        get { return objc_getAssociatedObject(self.base, TSEmptyKeys.autoShowNoNetPlace!) as? Bool }
        set {
            objc_setAssociatedObject(self.base, TSEmptyKeys.autoShowNoNetPlace!, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    ///空数据展示条件 return true 为展示
    public var checkEmptyStatusBlock: (()->Bool)? {
        get { return (objc_getAssociatedObject(self.base, TSEmptyKeys.checkToShowEmptyViewStatus!) as? (()->Bool)?)! }
        set {
            objc_setAssociatedObject(self.base, TSEmptyKeys.checkToShowEmptyViewStatus!, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 隐藏所有状态View
    public func hiddenAllStateView () {
        
        if let empty = self.emptyView {
            empty.isHidden = true
        }
        if let noNet = self.noNetworkView {
            noNet.isHidden = true
        }
    }
    
    /// 移除所有状态View 移除后需要重新添加View
    public func removeAllStateView () {
        if let empty = self.emptyView {
            if self.base.subviews.contains(empty) {
                empty.removeFromSuperview()
            }
            self.emptyView = nil
        }
        if let noNet = self.noNetworkView {
            if self.base.subviews.contains(noNet) {
                noNet.removeFromSuperview()
            }
            self.noNetworkView = nil
        }
    }
    
    /// 显示无网络页面
    public func showNoNetwork() {
        if let emptyViewTemp = self.emptyView {
            emptyViewTemp.isHidden = true
        }
        if let noNetView = self.noNetworkView {
            if !self.base.subviews.contains(noNetView) {
                self.base.addSubview(noNetView)
            }
            self.base.bringSubview(toFront: noNetView)
            noNetView.isHidden = false
        } else {
            debugPrint("未设置无网络View")
        }
    }
    /// 显示无数据页面 TableView CollectionView 使用
    public func reloadNoDataView() {
        if let noNetView = self.noNetworkView {
            noNetView.isHidden = true
        }
        if self.base is UIScrollView {
            if let canScroll = self.emptyViewCanScroll {
                (self.base as? UIScrollView)?.isScrollEnabled = canScroll
            } else {
                (self.base as? UIScrollView)?.isScrollEnabled = false
            }
        }
        showView()
    }
    
    /// 显示无数据页面 根据checkEmptyStatusBlock条件处理
    public func reloadNoDataViewOtherDataSource() {
        if let noNetView = self.noNetworkView {
            noNetView.isHidden = true
        }
        if self.base is UIScrollView {
            if let canScroll = self.emptyViewCanScroll {
                (self.base as? UIScrollView)?.isScrollEnabled = canScroll
            } else {
                (self.base as? UIScrollView)?.isScrollEnabled = false
            }
        }
        guard self.emptyView != nil else {
            debugPrint("未设置空数据View")
            return
        }
        guard self.checkEmptyStatusBlock != nil else {
            debugPrint("未配置空数据View展示条件")
            return
        }
        if let creatView = self.emptyView {
            if !self.base.subviews.contains(creatView) {
                self.base.addSubview(creatView)
            }
            //无网络的时候 校验并继续展示无网络展位图
            if TSNetworkMonitor.shared.reachabilityStatus == TSListenerStatus.tsNoNet {
                if self.checkEmptyStatusBlock!() {
                    self.showNoNetwork()
                }
            } else {
                creatView.isHidden = !self.checkEmptyStatusBlock!()
            }
        }
    }
    
    /// 内部显示空数据View
    private func showView () {
        guard self.emptyView != nil else {
            debugPrint("未设置空数据View")
            return
        }
        if let creatView = self.emptyView {
            
            if self.base.subviews.contains(creatView) {
                //TableView
                if self.base is UITableView {
                    creatView.isHidden = !emptyStateViewShouldShow(for: self.base as! UITableView)
                } else if self.base is UICollectionView {
                    creatView.isHidden = !emptyStateViewShouldShow(for: self.base as! UICollectionView)
                } else {
                    if self.checkEmptyStatusBlock != nil {
                        creatView.isHidden = !self.checkEmptyStatusBlock!()
                    } else {
                        creatView.isHidden = false
                    }
                }
            } else {
                self.base.addSubview(creatView)
                creatView.isHidden = false
            }
            if creatView.isHidden == false {
                //无网络的时候 校验并继续展示无网络展位图
                if TSNetworkMonitor.shared.reachabilityStatus == TSListenerStatus.tsNoNet {
                    self.showNoNetwork()
                }
            }
        }
    }
}

///泛型拓展不能添加Objc 方法 故放到这里
public extension UIView {
    @objc func checkNetworkChanged () {
        if self.tu.autoShowOrHiddenNoNetView != nil && !self.tu.autoShowOrHiddenNoNetView! {
            return
        }
        
        if TSNetworkMonitor.shared.reachabilityStatus == TSListenerStatus.tsNoNet {
            self.tu.showNoNetwork()
            self.tu.autoShowNoNetView()
        } else {
            self.tu.hiddenAllStateView()
            self.tu.autoHiddenNoNetView()
        }
    }
}
///网络切换自动控制 无网络展位图 私有方法
public extension TSUIKit where TU: UIView {
    public func autoShowNoNetView () {
        ///无网展位图 展示条件未空数据时
        if self.checkEmptyStatusBlock != nil {
            self.noNetworkView?.isHidden = !self.checkEmptyStatusBlock!()
        } else {
            if self.base is UITableView {
                self.noNetworkView?.isHidden = !emptyStateViewShouldShow(for: self.base as! UITableView)
            } else if self.base is UICollectionView {
                self.noNetworkView?.isHidden = !emptyStateViewShouldShow(for: self.base as! UICollectionView)
            } else {
                self.noNetworkView?.isHidden = false
            }
        }
    }
    public func autoHiddenNoNetView () {
        //默认隐藏无网络展位图后  展示空数据展位图
        if self.checkEmptyStatusBlock != nil {
            self.reloadNoDataViewOtherDataSource()
        } else {
            self.reloadNoDataView()
        }
    }
}




// MARK: - 默认配置空数据和无网络的View
public extension TSUIKit where TU: UIView {
    
    public func tsNormalEmptyView (_ img : UIImage , _ text : String) {
        let emptyView = TSEmptyNormalView.init(img, text)
        self.emptyView = emptyView
        self.emptyView!.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    public func tsNormalNonetWorkView (_ img : UIImage , _ text : String , _ noNetAction : (()->())?) {
        let noNetView = TSNoNetWorkNormalView.init(img, text, noNetAction)
        self.noNetworkView = noNetView
        self.noNetworkView!.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

public extension TSUIKit where TU: UIView {
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
