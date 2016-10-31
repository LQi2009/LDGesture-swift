//
//  LZCircleViewDelegate.swift
//  LZGesture-Swift
//
//  Created by Artron_LQQ on 2016/10/27.
//  Copyright © 2016年 Artup. All rights reserved.
//

import UIKit

@objc protocol LZCircleViewDelegate {
    
    @objc optional
    // 绘制无效时的回调,例如: 少于最低连线个数
    func circleView(_ view: LZCircleView, invalidConnect result: String)
    
    // 下面两个方法是当样式为Setting时用于更新UI提示
    @objc optional
    // 第一次绘制成功
    func circleView(_ view: LZCircleView, firstConnect result: String)
    @objc optional
    // 第二次绘制成功
    func circleView(_ view: LZCircleView, secondConnect result: String, isEqual equal: Bool)
    
    // 下面两个方法是当样式为Verity,
    // 验证结果
    @objc optional
    func circleView(_ view: LZCircleView, veritySuccess isSuccess: Bool)
    
    // 下面这个方法是当属性isAutoSaved为false时,用于返回用户保存的已设置手势密码
    @objc optional
    func stringSettedForCircleView(_ view: LZCircleView) -> String
    @objc optional
    ///
    /// - parameter view: LZCircleView
    ///
    /// - returns: 绘制完成的图像
    func circleView(_ view: LZCircleView, shotImage img: UIImage)
}
