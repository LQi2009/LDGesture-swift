//
//  LZGestureViewController.swift
//  LZGesture-Swift
//
//  Created by Artron_LQQ on 2016/10/28.
//  Copyright © 2016年 Artup. All rights reserved.
//


enum LZGestureStyle {
    case Setting, Verity, Update, Screen
}

import UIKit

class LZGestureViewController: UIViewController, LZCircleViewDelegate {

    var style: LZGestureStyle = .Setting
    var delegate: LZGestureControllerDelegate?
    
    
    var lockView: LZCircleView!
    var titleLabel: UILabel!
    var imageView: UIImageView!
    var warnLabel: LZWarnLabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if style != .Screen {
            
            titleLabel.sizeToFit()
            titleLabel.center = CGPoint.init(x: self.view.center.x, y: 42)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = LZColor.colorP3FromRGB(13, 52, 89)
        
        
        
        self.setupMain()
    }
    
    func setupCustonNavi() {
        
        titleLabel = UILabel.init()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        self.view.addSubview(titleLabel)
        
        let backButton = UIButton.init(type: .custom)
        backButton.frame = CGRect.init(x: 10, y: 20, width: 40, height: 44)
        backButton.setTitle("╳", for: .normal)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        self.view.addSubview(backButton)
    }

    func backButtonClick() {
        
        self.back()
        self.delegate?.gestureControllerCancel?(self)
    }
    
    func back() {
        
        if self.navigationController != nil {
            
        _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func delayBack() {
        
        let dalay = DispatchTime.now() + 0.4
        DispatchQueue.main.asyncAfter(deadline: dalay) { 
            
            self.back()
        }
    }
    
    func showIn(viewController vc: UIViewController, style: LZGestureStyle) {
        
        if style != .Screen {
            
            self.setupCustonNavi()
        }
        
        vc.present(self, animated: true, completion: nil)
        self.style = style
        

        
        switch style {
        case .Setting:
            self.titleLabel.text = "设置密码"
            self.lockView.type = .Setting
            self.warnLabel.warnNormal()
        case .Verity:
            self.titleLabel.text = "验证密码"
            self.lockView.type = .Verity
             self.warnLabel.warnNormal()
            imageView.image = UIImage.init(named: "icon")
        case .Update:
            self.titleLabel.text = "修改密码"
            self.lockView.type = .Verity
            self.warnLabel.warnOld()
        case .Screen:
           
            self.lockView.type = .Verity
            self.imageView.image = UIImage.init(named: "icon")
            self.warnLabel.warnNormal()
        }
    }
    
    func setupMain() {
        
        lockView = LZCircleView.init()
        lockView.delegate = self
        self.view.addSubview(lockView)
        
        imageView = UIImageView.init()
        imageView.bounds = CGRect.init(x: 0, y: 0, width: 80, height: 80)
        imageView.center = CGPoint.init(x: self.view.center.x, y: 120)
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        imageView.image = lockView.defaultImage()
        
        warnLabel = LZWarnLabel.init()
        warnLabel.bounds = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 14)
        warnLabel.center = CGPoint.init(x: self.view.center.x, y: lockView.frame.minY - 30)
        
        self.view.addSubview(warnLabel)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: -LZCircleViewDelegate
    func circleView(_ view: LZCircleView, shotImage img: UIImage) {
        if self.style == .Setting || self.style == .Update {
            
            imageView.image = img
        }
    }
    // 绘制无效时的回调,例如: 少于4个点
    func circleView(_ view: LZCircleView, invalidConnect result: String) {
        
        warnLabel.warnCountError()
    }
    // 第一次绘制结束
    func circleView(_ view: LZCircleView, firstConnect result: String) {
        
        warnLabel.warnSecondDraw()
    }
    // 第二次绘制结束
    func circleView(_ view: LZCircleView, secondConnect result: String, isEqual equal: Bool) {
        
        if equal == false {
            
            warnLabel.warnErrorForDifferent()
        } else {
            
            warnLabel.warnSuccess()
            // 保存密码到沙盒
            LZGestureTool.save(gesture: result)
            self.delayBack()
            
            self.delegate?.gestureController?(self, didSetted: result)
        }
    }
    
    func circleView(_ view: LZCircleView, veritySuccess isSuccess: Bool) {
        
        if self.style == .Verity {
            
            if isSuccess {
                
                self.back()
                
                self.delegate?.gestureControllerVeritedSuccess?(self)
            } else {
                
                warnLabel.warnFaildError()
            }
        } else if self.style == .Update {
            
            if isSuccess {
                
                self.lockView.type = .Setting
                warnLabel.warnNormal()
                imageView.image = lockView.defaultImage()
            } else {
                
                warnLabel.warnFaildError()
            }
        }else if self.style == .Screen {
            if isSuccess {
                
                self.back()
                self.delegate?.gestureControllerVeritedSuccess?(self)
            } else {
                
                warnLabel.warnFaildError()
            }
        }
    }
    
    func stringSettedForCircleView(_ view: LZCircleView) -> String {
        
        return LZGestureTool.getGesture()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

@objc protocol LZGestureControllerDelegate {
    
    @objc optional
    func gestureController(_ vc: LZGestureViewController, didSetted result: String)
    @objc optional
    func gestureController(_ vc: LZGestureViewController, didUpdate result: String)
    @objc optional
    func gestureControllerVeritedSuccess(_ vc: LZGestureViewController)
    @objc optional
    func gestureControllerCancel(_ vc: LZGestureViewController)
}

