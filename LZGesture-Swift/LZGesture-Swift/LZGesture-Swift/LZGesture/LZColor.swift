//
//  LZColorTool.swift
//  LZAccount-swift
//
//  Created by Artron_LQQ on 2016/9/27.
//  Copyright © 2016年 Artup. All rights reserved.
//

import UIKit

class LZColor: NSObject {

    //MARK: - 新颜色
//    @available(*, deprecated:3.0, message:"Use newer snp.* syntax.")
    static func colorP3FromRGB(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> (UIColor) {
        
        if #available(iOS 10.0, *) {
            return UIColor.init(displayP3Red: r/255.0,
                                green: g/255.0,
                                blue: b/255.0,
                                alpha: 1.0)
        } else {
            // Fallback on earlier versions
            
            return UIColor(red: r/255.0,
                           green: g/255.0,
                           blue: b/255.0,
                           alpha: 1.0)
        }
    }
    
    /// 十六进制色值转换为颜色
    ///
    /// - parameter hex: 十六进制色值
    ///
    /// - returns: 转换的颜色
    static  func colorP3FromHex(_ hex: UInt32) ->(UIColor) {
        
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue  = CGFloat((hex & 0x0000FF)) / 255.0
        
        
        if #available(iOS 10.0, *) {
            return UIColor.init(displayP3Red: red, green: green, blue: blue, alpha: 1.0)
        } else {
            // Fallback on earlier versions
            
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    /// 十六进制色值字符串转换为颜色
    ///
    /// - parameter string: 十六进制色值字符串
    ///
    /// - returns: 转换的颜色
    static func colorP3FromString(_ string: String) -> UIColor {
        
        var cStr = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if cStr.characters.count < 6 {
            
            return UIColor.white
        }
        
        if cStr.hasPrefix("#") {
            cStr = cStr.substring(from: cStr.index(cStr.startIndex, offsetBy: 1))
        }
        
        if cStr.characters.count != 6 {
            return UIColor.white
        }
        
        var range = NSRange.init()
        range.location = 0
        range.length = 2
        
        let ocStr = cStr as NSString
        
        let rStr = ocStr.substring(with: range)
        range.location = 2
        let gStr = ocStr.substring(with: range)
        range.location = 4
        let bStr = ocStr.substring(with: range)
        
        var r = UInt32()
        var g = UInt32()
        var b = UInt32()
        
        Scanner(string: rStr).scanHexInt32(&r)
        Scanner(string: gStr).scanHexInt32(&g)
        Scanner(string: bStr).scanHexInt32(&b)
        
        if #available(iOS 10.0, *) {
            return UIColor.init(displayP3Red: CGFloat(Double(r)/255.0),
                                green: CGFloat(Double(g)/255.0),
                                blue: CGFloat(Double(b)/255.0),
                                alpha: 1.0)
        } else {
            // Fallback on earlier versions
            
            return UIColor(red: CGFloat(Double(r)/255.0),
                           green: CGFloat(Double(g)/255.0),
                           blue: CGFloat(Double(b)/255.0),
                           alpha: 1.0)
        }
    }
    
    /// 随机颜色
    ///
    /// - returns: 返回随机颜色
    static func randomP3Color() -> (UIColor) {
        
        let r = CGFloat(arc4random()%255)
        let g = CGFloat(arc4random()%255)
        let b = CGFloat(arc4random()%255)
        
        if #available(iOS 10.0, *) {
            return UIColor.init(displayP3Red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
        } else {
            // Fallback on earlier versions
            return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
        }
    }
    
    /// 生成指定颜色的图片
    ///
    /// - returns: 相应颜色的图片
    func imageFrom(color: UIColor, size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        color.set()
        UIRectFill(CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }

}
