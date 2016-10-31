//
//  LZGestureTool.swift
//  LZGesture-Swift
//
//  Created by Artron_LQQ on 2016/10/28.
//  Copyright © 2016年 Artup. All rights reserved.
//
// 手势相关设置管理工具

import UIKit

class LZGestureTool {

    static func save(gesture psw: String) {
        
        let uf = UserDefaults.standard
        
        uf.set(psw, forKey: "usrSettedGesturePassword")
        uf.synchronize()
    }
    
    static func getGesture() -> String {
        
        let uf = UserDefaults.standard
        
        return uf.object(forKey: "usrSettedGesturePassword") as! String
    }
    
    static func isGestureSetted() -> Bool {
        
        let str = self.getGesture()
        
        return str.characters.count > 0
    }
    
    static func isGestureEnableByUser() -> Bool {
        
        let uf = UserDefaults.standard
        var enable: Bool = false
        
        if let obj = uf.object(forKey: "gestureEnableByUserKey") {
            
            enable = obj as! Bool
        }
        
        return enable
    }
    
    static func saveGestureEnableByUser(_ enable: Bool) {
        
        let uf = UserDefaults.standard
        uf.set(enable, forKey: "gestureEnableByUserKey")
        uf.synchronize()
    }
    
    static func isGestureEnable() -> Bool {
        
        let setted = self.isGestureSetted()
        let enableByUser = self.isGestureEnableByUser()
        
        return setted&&enableByUser
    }
    
}
