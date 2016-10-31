//
//  LZCircle.swift
//  LZGesture-Swift
//
//  Created by Artron_LQQ on 2016/10/26.
//  Copyright © 2016年 Artup. All rights reserved.
//
// 圆点视图,

import UIKit

/// 普通状态下外空心圆颜色
private let LZCircleStateNormalOutsideColor = LZColor.colorP3FromRGB(241, 241, 241)
/// 选中状态下外空心圆颜色
private let LZCircleStateSelectedOutsideColor = LZColor.colorP3FromRGB(34, 178, 246)
/// 错误状态下外空心圆颜色
private let LZCircleStateErrorOutSideColor = LZColor.colorP3FromRGB(254, 82, 92)

/// 空心圆圆环宽度
private let LZCircleEdgeWidth: CGFloat = 1.4
/// 内部实心圆占空心圆的比例系数
private let LZCircleRadio: CGFloat = 0.4


/// 普通状态下内实心圆颜色
private let LZCircleStateNormalInsideColor = UIColor.clear
/// 选中状态下内实心圆颜色
private let LZCircleStateSelectedInsideColor = LZColor.colorP3FromRGB(34, 178, 246)
/// 错误状态下内实心圆颜色
private let LZCircleStateErrorInsideColor = LZColor.colorP3FromRGB(254, 82, 92)


/// 普通状态下三角形颜色
private let LZCircleStateNormalTrangleColor = UIColor.clear
/// 选中状态下三角形颜色
private let LZCircleStateSelectedTrangleColor = LZColor.colorP3FromRGB(34, 178, 246)
/// 错误状态下三角形颜色
private let LZCircleStateErrorTrangleColor = LZColor.colorP3FromRGB(254, 82, 92)
/// 三角形边长
private let LZConfig_trangleLength: CGFloat = 14.0

enum LZCircleState: Int {
    
    case Normal = 1
    case Selected
    case Error
    case LastOneSelected
    case LastOneError
}

//enum LZCircleType: Int {
//    case Info = 1
//    case Gesture
//}

class LZCircle: UIView {

    var state: LZCircleState = .Normal {
        
        willSet {
            
            self.setNeedsDisplay()
        }
    }
//    var type: LZCircleType = .Gesture
    
    var isArrow: Bool = true
    var angle: CGFloat = 0 {
        
        willSet {
            
            self.setNeedsDisplay()
        }
    }
    
    private var outCircleColor: UIColor! {
        
        get {
            var color: UIColor?
            
            switch self.state {
            case .Normal:
                color = LZCircleStateNormalOutsideColor
            case .Selected:
                color = LZCircleStateSelectedOutsideColor
            case .Error:
                color = LZCircleStateErrorOutSideColor
            case .LastOneSelected:
                color = LZCircleStateSelectedOutsideColor
            case .LastOneError:
                color = LZCircleStateErrorOutSideColor
            }
            
            return color!
        }

    }
    private var inCircleColor: UIColor! {
        
        get {
            var color: UIColor?
            
            switch self.state {
            case .Normal:
                color = LZCircleStateNormalInsideColor
            case .Selected:
                color = LZCircleStateSelectedInsideColor
            case .Error:
                color = LZCircleStateErrorInsideColor
            case .LastOneSelected:
                color = LZCircleStateSelectedInsideColor
            case .LastOneError:
                color = LZCircleStateErrorInsideColor
            }
            
            return color!
        }

    }
    private var trangleColor: UIColor! {
        
        get {
            var color: UIColor?
            
            switch self.state {
            case .Normal:
                color = LZCircleStateNormalTrangleColor
            case .Selected:
                color = LZCircleStateSelectedTrangleColor
            case .Error:
                color = LZCircleStateErrorTrangleColor
            case .LastOneSelected:
                color = LZCircleStateNormalTrangleColor
            case .LastOneError:
                color = LZCircleStateNormalTrangleColor
            }
            
            return color!
        }
    }
    
    init () {
        
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.clear
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let ctx = UIGraphicsGetCurrentContext()
        
        var radio: CGFloat = 0.0
        let circleRect = CGRect.init(x: LZCircleEdgeWidth, y: LZCircleEdgeWidth, width: rect.width - 2*LZCircleEdgeWidth, height: rect.height - 2*LZCircleEdgeWidth)
        
        radio = LZCircleRadio
//        if self.type == .Gesture {
//            
//            
//        } else if self.type == .Info {
//            radio = 1;
//        }
        
        self.transFormCtx(ctx: ctx!, rect: rect)
        
        self.drawEmptyCircle(withContext: ctx!, rect: circleRect, color: self.outCircleColor)
        
        self.drawSolidCircle(withContext: ctx!, rect: rect, radio: radio, color: self.inCircleColor)
        
        if self.isArrow {
            
            self.drawTrangleWith(context: ctx!, topPoint: CGPoint.init(x: rect.width/2, y: 10), length: LZConfig_trangleLength, color: self.trangleColor)
        }
    }
    //MARK: -画空心圆
    func drawEmptyCircle(withContext ctx: CGContext, rect: CGRect, color: UIColor) {
        
        let circlePath = CGMutablePath.init()
        circlePath.addEllipse(in: rect)
        ctx.addPath(circlePath)
        
        color.set()
        ctx.setLineWidth(LZCircleEdgeWidth)
        ctx.strokePath()
    }
    //MARK: -画实心圆
    func drawSolidCircle(withContext ctx: CGContext, rect: CGRect, radio: CGFloat, color: UIColor) {
        
        let circlePath = CGMutablePath.init()
        circlePath.addEllipse(in: CGRect.init(x: rect.width/2 * (1 - radio) + LZCircleEdgeWidth, y: rect.height/2 * (1 - radio) + LZCircleEdgeWidth, width: rect.width * radio - LZCircleEdgeWidth*2, height: rect.height*radio - LZCircleEdgeWidth*2))
        
        color.set()
        ctx.addPath(circlePath)
        ctx.fillPath()
    }
    //MARK: -画三角形
    func drawTrangleWith(context ctx: CGContext, topPoint point: CGPoint, length: CGFloat, color: UIColor) {
        
        let trianglePathM  = CGMutablePath.init()
        trianglePathM.move(to: point)
        trianglePathM.addLine(to: CGPoint.init(x: point.x - length/2, y: point.y + length/2))
        trianglePathM.addLine(to: CGPoint.init(x: point.x + length/2, y: point.y + length/2))
        
        ctx.addPath(trianglePathM)
        
        color.set()
        ctx.fillPath()
    }
    
    func transFormCtx(ctx: CGContext, rect: CGRect) {
        
        let translateXY = rect.size.width * 0.5
        
        ctx.translateBy(x: translateXY, y: translateXY)
        ctx.rotate(by: self.angle)
        
        ctx.translateBy(x: -translateXY, y: -translateXY)
        
    }
}
