//
//  UIButton+TSUIKit.swift
//  TSCustomUIKit
//
//  Created by 小铭 on 2018/9/10.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit
import Kingfisher

extension TSUIKit where TU: UIButton {
    /// 设置图片
    public func setImage(url : String?,_ status : UIControlState = .normal) {
        
        guard let urlStr = url, urlStr.count > 1 else {
            return
        }
        
        guard let url = URL(string: urlStr) else {
            return
        }
        
        let res : ImageResource = ImageResource(downloadURL: url)
        self.base.kf.setImage(with: res, for: status)
    }
    
    /// 设置图片
    ///
    /// - Parameters:
    ///   - url: 图片地址
    ///   - placeHolder: 默认图
    public func setImage(url : String?,_ status : UIControlState = .normal, placeHolder: UIImage) {
        
        guard let urlStr = url, urlStr.count > 1 else {
            self.base.setImage(placeHolder, for: status)
            return
        }
        
        guard let url = URL(string: urlStr) else {
            return
        }
        
        let res : ImageResource = ImageResource(downloadURL: url)
        
        self.base.kf.setImage(with: res, for: status, placeholder: placeHolder, options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    /// 设置圆角图片
    ///
    /// - Parameters:
    ///   - urlString: 图片地址
    ///   - corner: 圆角大小
    ///   - imageSize: 期望获取到的图片大小
    ///   - placeHolder: 默认图片
    public func setImagea(urlString: String?, corner: CGFloat, imageSize: CGSize? = nil,_ status : UIControlState = .normal, placeHolder: UIImage? = nil) {
        
        guard let url = URL(string: urlString!) else {
            self.base.setImage(placeHolder, for: status)
            return
        }
        let resource = ImageResource.init(downloadURL: url)
        let cache = KingfisherManager.shared.cache
        let optionsInfo = [KingfisherOptionsInfoItem.transition(ImageTransition.fade(0.1)), KingfisherOptionsInfoItem.targetCache(cache), KingfisherOptionsInfoItem.processor(RoundCornerImageProcessor(cornerRadius: corner, targetSize: imageSize))]
        self.base.kf.setImage(with: resource, for: status, placeholder: placeHolder, options: optionsInfo, progressBlock: nil, completionHandler: nil)
    }
    
    /// 设置图片
    ///
    /// - Parameters:
    ///   - url: 图片地址
    ///   - placeHolder: 默认图
    ///   - progressBlock: 图片加载进度
    ///   - completionBlock: 完成回调
    public func setImage(url : String?,_ status : UIControlState = .normal, placeHolder: UIImage?, progressBlock : ((_ receivedSize: Int64, _ totalSize: Int64) -> Void)?, completionBlock : ((_ image: Image?, _ error: NSError?) -> Void)? ) {
        
        guard let urlStr = url, urlStr.count > 1 else {
            return
        }
        
        guard let url = URL(string: urlStr) else {
            return
        }
        
        let res : ImageResource = ImageResource(downloadURL: url)
        
        self.base.kf.setImage(with: res, for: status, placeholder: placeHolder, options: nil, progressBlock: progressBlock) { (image, error, _, _) in
            self.base.setImage(image, for: status)
            if (completionBlock != nil) {
                completionBlock!(image,error)
            }
        }
    }
}

