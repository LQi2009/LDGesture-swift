//
//  LZWarnLabel.swift
//  LZGesture-Swift
//
//  Created by Artron_LQQ on 2016/10/28.
//  Copyright © 2016年 Artup. All rights reserved.
//

import UIKit

class LZWarnLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textAlignment = .center
        self.font = UIFont.systemFont(ofSize: 12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 绘制解锁密码
    func warnNormal() {
        
        self.text = "绘制解锁密码"
        self.textColor = LZColor.colorP3FromRGB(241, 241, 241)
    }
    
    /// 最少连接4个点,请重新绘制
    func warnCountError() {
        
        self.text = "最少连接4个点,请重新绘制"
        self.textColor = LZColor.colorP3FromRGB(254, 82, 92)
    }
    
    /// 再次绘制解锁密码
    func warnSecondDraw() {
        self.text = "再次绘制解锁密码"
        self.textColor = LZColor.colorP3FromRGB(241, 241, 241)
    }
    
    /// 与上次绘制不一致,请重新绘制
    func warnErrorForDifferent() {
        self.text = "与上次绘制不一致,请重新绘制"
        self.textColor = LZColor.colorP3FromRGB(254, 82, 92)
    }
    
    /// 请输入旧密码
    func warnOld() {
        self.text = "请输入旧密码"
        self.textColor = LZColor.colorP3FromRGB(241, 241, 241)
    }
    
    /// 密码错误
    func warnFaildError() {
        self.text = "密码错误"
        self.textColor = LZColor.colorP3FromRGB(254, 82, 92)
        self.layer.shake()
    }
    
    /// 设置成功
    func warnSuccess() {
        self.text = "设置成功"
        self.textColor = LZColor.colorP3FromRGB(77, 195, 85)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

// 抖动动画
extension CALayer {
    
    func shake() {
        
        let kfa = CAKeyframeAnimation.init(keyPath: "transform.translation.x")
        kfa.values = [-5, 0, 5, 0, -5, 0, 5, 0]
        kfa.duration = 0.3
        kfa.repeatCount = 2
        
        kfa.isRemovedOnCompletion = true
        
        self.add(kfa, forKey: "shake")
    }
}
