//
//  LZCircleView.swift
//  LZGesture-Swift
//
//  Created by Artron_LQQ on 2016/10/26.
//  Copyright © 2016年 Artup. All rights reserved.
//
// 手势解锁视图
// 这只是一个手势解锁的九宫格布局的view,其他提示信息需要自己定义
// 包含各种情况下的九宫格的状态改变,其他相应的UI变化可在代理方法中设置

import UIKit

// 自动保存时的key
let kLZAutoSavedPasswordKey = "kLZAutoSavedPasswordForLZCircleView"
// 每次绘制,自动截取一个图片,保存的图片名称
let kLZAutoSavedGestureImageName = "autoSavedDefault.png"


/// 普通状态下连线颜色
private let LZCircleConnectLineNormalColor = LZColor.colorP3FromRGB(34, 178, 246)
/// 错误状态下连线颜色
private let LZCircleConnectLineErrorColor = LZColor.colorP3FromRGB(254, 82, 92)

/// 链接的圆最少个数
private let LZConfig_circleSetCountLeast = 4
/// 连线宽度
private let LZCircleConnectLineWidth: CGFloat = 2.0
/// 单个圆的半径
private let LZCircleRadius: CGFloat = 30.0

/// 整个解锁view居中时,距离屏幕左右边距
private let LZCircleViewEdgeMargin: CGFloat = 30.0
/// 整个解锁View的Center.y值 在当前屏幕的3/5位置
private let LZCircleViewCenterY = UIScreen.main.bounds.height * 3/5

// 视图所处状态
enum LZCircleViewType {
    
    case Setting, Verity
}

class LZCircleView: UIView {

    
    var delegate: LZCircleViewDelegate?
    
    var isClip: Bool = true
    // 是否自动保存设置成功的手势密码
    // 保存在UserDefault中,可通过key: kLZAutoSavedPasswordKey 获取
    // 默认为true
    // 若设置为false,需要实现代理stringSettedForCircleView,否则无法使用Verity样式
    var isAutoSaved: Bool = true
    
    var isArrow: Bool = true {
        
        didSet {
            
            for circle in self.subviews {
                
                let cir = circle as! LZCircle
                cir.isArrow = isArrow
            }
        }
    }
    
    var type: LZCircleViewType = .Setting
    
    // private property
    private var circles: [LZCircle] = []
    private var currentPoint: CGPoint = CGPoint.zero
    private var isClean: Bool = false
    private var tempGesturePsw: String = ""
    private var isTouchBegin: Bool = false
    
    init(withType type: LZCircleViewType, clip: Bool, arrow: Bool) {
        super.init(frame: CGRect.zero)
        
        self.prepare()
        
        self.type = type
        self.isClip = clip
        self.isArrow = arrow
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        self.prepare()
    }
    
    private func prepare() {
        
        self.bounds = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width - LZCircleViewEdgeMargin*2, height: UIScreen.main.bounds.width - LZCircleViewEdgeMargin*2)
        
        self.center = CGPoint.init(x: UIScreen.main.bounds.width/2, y: LZCircleViewCenterY)
        
//        self.isClip = true
//        self.isArrow = true
        
        self.backgroundColor = UIColor.clear
        
        for _ in 0..<9 {
            
            let circle = LZCircle.init()
//            circle.type = .Gesture
            circle.isArrow = self.isArrow
            self.addSubview(circle)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let itemViewWH: CGFloat = LZCircleRadius*2
        let marginValue: CGFloat = (self.frame.width - 3*itemViewWH) / 3.0
        
        for i in 0..<self.subviews.count {
            
            let row = i % 3
            let col = i / 3
            
            let x: CGFloat = marginValue * CGFloat(row) + CGFloat(row)*itemViewWH + marginValue/2
            let y: CGFloat = marginValue*CGFloat(col) + CGFloat(col) * itemViewWH + marginValue/2
            
            let frame = CGRect.init(x: x, y: y, width: itemViewWH, height: itemViewWH)
            
            let subView = self.subviews[i]
            
            subView.frame = frame
            subView.tag = i + 1
        }
        
        self.saveDefaultImage()
    }
    //MARK: -touch Begin Moved End
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.resetWhenGesureEndded()
        isTouchBegin = true
        
        self.currentPoint = CGPoint.zero
        
        let touch = touches.first
        let point = touch?.location(in: self)
        
        for vi in self.subviews {
            
            let circle = vi as! LZCircle
            
            if circle.frame.contains(point!) {
                
                circle.state = .Selected
                self.circles.append(circle)
            }
        }
        
        self.setLastCircleState(.LastOneSelected)
        self.setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.currentPoint = CGPoint.zero
        
        let touch = touches.first
        let point = touch?.location(in: self)
        
        for vi in self.subviews {
            
            let circle = vi as! LZCircle
            // 判断当前触摸点是否包含在圆内
            if circle.frame.contains(point!) {
                
                if self.circles.contains(circle) {
                    
                } else {
                    // 如果当前圆没有记录,记录一下
                    self.circles.append(circle)
                    
                    self.angleConnectLine()
                }
            } else {
                
                self.currentPoint = point!
            }
        }
        // 修改记录的圆点为选中状态
        for vi in self.circles {
            
            vi.state = .Selected
            
//            if self.type != .Setting {
//                
//                vi.state = .Selected
//            }
        }
        
        self.setLastCircleState(.LastOneSelected)
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.isClean = false
        
        let gesture: String = self.getGestureResult()
        
        let length = gesture.characters.count
        
        if length == 0 {
            
            return
        }
        
        switch self.type {
        case .Setting:
            self.gestureEndSettingWith(result: gesture)
        case .Verity:
            self.gestureEndVerityWith(result: gesture)
        }
        
        self.errorDisplay()
    }
    
    private func resetWhenGesureEndded() {
        
        if isTouchBegin {
            isTouchBegin = false
            
            self.delegate?.circleView?(self, shotImage: self.shotView())
        }
        
        if !self.isClean {
            
            self.changeSelectedCircleState(.Normal)
            
            self.circles.removeAll()
            
            for vi in self.subviews {
                
                let circle = vi as! LZCircle
                
                circle.angle = 0
            }
            
            self.isClean = true
        }
    }
    
    private func setLastCircleState(_ state: LZCircleState) {
        
        let circle = self.circles.last
        circle?.state = state
    }
    
    
    private func gestureEndVerityWith(result: String) {
        
        var autoSaved = ""
        if self.isAutoSaved {
            
            autoSaved = self.getGesturePsw()
        }
        
        if let userSaved = self.delegate?.stringSettedForCircleView?(self) {
            
            autoSaved = userSaved
        }
        
        
        if autoSaved == result {
            
            //MARK: 验证通过,通知代理
            self.delegate?.circleView?(self, veritySuccess: true)
            
        } else {
            
            self.delegate?.circleView?(self, veritySuccess: false)
            self.changeSelectedCircleState(.Error)
        }
        
    }
    private func gestureEndSettingWith(result: String) {
        
        let length = result.characters.count
        if length < LZConfig_circleSetCountLeast {
            
            //少于四个点时的回调代理方法
            self.delegate?.circleView?(self, invalidConnect: result)
            
            self.changeSelectedCircleState(.Error)
        } else {
            
            if tempGesturePsw.characters.count < LZConfig_circleSetCountLeast {
                //MARK: -第一次绘制结束
                tempGesturePsw = result
                
                self.delegate?.circleView?(self, firstConnect: result)
                
            } else {
                // MARK: - 第二次绘制结束
                
                if result == tempGesturePsw {
                    
                    self.delegate?.circleView?(self, secondConnect: result, isEqual: true)
                    
                    // 内部保存
                    if self.isAutoSaved {
                        
                        self.saveGesturePsw(tempGesturePsw)
                    }
                    
                } else {
                    
                    self.delegate?.circleView?(self, secondConnect: result, isEqual: false)
                    self.changeSelectedCircleState(.Error)
                    tempGesturePsw = ""
                }
            }
        }
    }
    
    private func changeSelectedCircleState(_ state: LZCircleState) {
        
        for circle in self.circles {
            
            circle.state = state
            
            if state == .Error {
                
                if self.circles.index(of: circle) == self.circles.count - 1 {
                    
                    circle.state = .LastOneError
                }
            }
        }
        
        self.setNeedsDisplay()
    }
    
    private func getGestureResult() -> String {
        
        var psw: String = ""
        
        for vi in self.circles {
            
            psw += "\(vi.tag)"
        }
        
        return psw
    }
    
    private func saveGesturePsw(_ result: String) {
        
        let uf = UserDefaults.standard
        uf.set(result, forKey: kLZAutoSavedPasswordKey)
        uf.synchronize()
    }
    
    private func getGesturePsw() -> String {
        
        let uf = UserDefaults.standard
        
        return uf.object(forKey: kLZAutoSavedPasswordKey) as! String
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        if self.circles.count <= 0 {
            
            return
        }
        
        var color: UIColor = UIColor()
        
        let circle = self.circles.first
        
        if circle?.state == .Error {
            
            color = LZCircleConnectLineErrorColor
        } else {
            color = LZCircleConnectLineNormalColor
        }
        
        self.connectCirclesIn(rect: rect, lineColor: color)
    }

    private func connectCirclesIn(rect: CGRect, lineColor: UIColor) {
        
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.addRect(rect)
        
        if self.isClip {
            
            for vi in self.subviews {
                
                ctx?.addEllipse(in: vi.frame)
                
            }
        }
        
        ctx?.clip()
        
        for circle in self.circles {
            
            if circle.isEqual(self.circles.first) {
                
                ctx?.move(to: circle.center)
            } else {
                ctx?.addLine(to: circle.center)
            }
        }
        
        if !self.currentPoint.equalTo(CGPoint.zero) {
            
            let circleState = self.circles.first?.state
            
            for _ in self.subviews {
                
                if circleState == .Error || circleState == LZCircleState.LastOneError {
                    
                } else {
                    ctx?.addLine(to: self.currentPoint)
                }
            }
        }
        
        ctx?.setLineCap(.round)
        ctx?.setLineJoin(.round)
        
        ctx?.setLineWidth(LZCircleConnectLineWidth)
        
        lineColor.set()
        ctx?.strokePath()
    }
    
    private func angleConnectLine() {
        
        if self.circles.count <= 1 {
            
            return
        }
        
        let lastOne = self.circles.last
        
        let lastTwo = self.circles[self.circles.count - 2]
        
        let last1_x = lastOne?.center.x
        let last1_y = lastOne?.center.y
        let last2_x = lastTwo.center.x
        let last2_y = lastTwo.center.y
        
        let angle = atan2(last1_y! - last2_y, last1_x! - last2_x) + CGFloat(M_PI_2)
        
        lastTwo.angle = angle
        
        
        // 处理跳线
        let center = self.centerPoint(atPointOne: (lastOne?.center)!, pointTwo: lastTwo.center)
        
        
        
        if let centerCircle: LZCircle = self.findWhichCircleContainThePoint(center) {
            
            if !self.circles.contains(centerCircle) {
                
                self.circles.insert(centerCircle, at: self.circles.count - 1)
            }
        }
    }
    
    private func centerPoint(atPointOne pointOne: CGPoint, pointTwo: CGPoint) -> CGPoint {
        
        let x1 = pointOne.x > pointTwo.x ? pointOne.x : pointTwo.x
        let x2 = pointOne.x < pointTwo.x ? pointOne.x : pointTwo.x
        let y1 = pointOne.y > pointTwo.y ? pointOne.y : pointTwo.y
        let y2 = pointOne.y < pointTwo.y ? pointOne.y : pointTwo.y
        
        return CGPoint.init(x: (x1+x2)/2, y: (y1+y2)/2)
    }
    
    
    private func errorDisplay() {
        
        let state = self.circles.first?.state
        
        if state == LZCircleState.Error || state == LZCircleState.LastOneError {
            
            let delay = DispatchTime.now() + 1.0
            
            DispatchQueue.main.asyncAfter(deadline: delay, execute: { 
                
                self.resetWhenGesureEndded()
            })
        } else {
            
            self.resetWhenGesureEndded()
        }
        
    }
    
    private func findWhichCircleContainThePoint(_ point: CGPoint) -> LZCircle? {
        
        var centerCircle: LZCircle? = nil
        
        for vi in self.subviews {
            
            let circle = vi as? LZCircle
            
            if (circle?.frame.contains(point))! {
                
                centerCircle = circle!
            }
        }
        
        if let circle = centerCircle {
            
            if !self.circles.contains(circle) {
                
                centerCircle?.angle = self.circles[self.circles.count - 2].angle
            }
        }
        return centerCircle
    }

    func saveDefaultImage() {
        
        let path = NSHomeDirectory().appendingFormat("/Documents/%@", kLZAutoSavedGestureImageName)
        var img = UIImage.init(contentsOfFile: path)
        
        if img == nil {
            
            img = self.shotView()
            
            let data = UIImagePNGRepresentation(img!)
            
           do {
            try data?.write(to: URL.init(fileURLWithPath: path))

            } catch  {
                
            }
        }
        
        
    }
    
    func defaultImage() -> UIImage {
        
        let path = NSHomeDirectory().appendingFormat("/Documents/%@", kLZAutoSavedGestureImageName)
        var img = UIImage.init(contentsOfFile: path)
        
        if img == nil {
            
            img = self.shotView()
        }
        
        return img!
    }
    
    func shotView() -> UIImage {
        
        UIGraphicsBeginImageContext(self.frame.size)
        let ctx = UIGraphicsGetCurrentContext()
        
        self.layer.render(in: ctx!)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
}
