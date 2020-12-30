//
//  UIViewExtension.swift
//  PTSDK
//
//  Created by PainTypeZ on 2020/12/29.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public enum ScaleWithScreenWidthType {
    case constraint
    case fontSize
    case cornerRadius
    case all
}

// MARK: - 约束缩放计算
public struct PTScaleSetting {
    static var baseScreenWidth: CGFloat = 375.0
    static var baseScreenHeight: CGFloat = 375.0
    
    static var widthScale: CGFloat {
        return UIScreen.main.bounds.width / baseScreenWidth
    }
    static var heightScale: CGFloat {
        return UIScreen.main.bounds.height / baseScreenWidth
    }
}

public enum BorderDirection {
    case top
    case bottom
    case left
    case right
}

// MARK: - UIVIew Extension
public extension UIView {
    /// 设置与父视图四边相等的约束
    private func equalToSuperView() {
        let leading = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0)
        let trailing = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0)
        let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0)
        let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0)
        addConstraints([leading, trailing, top, bottom])
        superview?.updateConstraintsIfNeeded()
    }
    /// 添加模糊效果（UIVisualEffectView）
    func addBlurEffect() {
        //创建一个模糊效果
        let blurEffect = UIBlurEffect(style: .light)
        //创建一个承载模糊效果的视图
        let blurView = UIVisualEffectView(effect: blurEffect)
        addSubview(blurView)
        blurView.equalToSuperView()
    }
    /// 添加模糊效果（UIVibrancyEffect）
    func addBlurEffectWithUIVibrancyEffect() {
        //创建一个模糊效果
        let blurEffect = UIBlurEffect(style: .light)
        //创建一个承载模糊效果的视图
        let blurView = UIVisualEffectView(effect: blurEffect)
        //创建并添加vibrancy视图
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect:vibrancyEffect)

        blurView.contentView.addSubview(vibrancyView)
        vibrancyView.equalToSuperView()

        addSubview(blurView)
        blurView.equalToSuperView()
    }
    /// 按屏幕宽缩放，依赖PTScaleSetting，ScaleWithScreenWidthType
    func scale(types: [ScaleWithScreenWidthType], isScaleSubViews: Bool = true, exceptViews: [AnyObject]? = nil) {
        let scaleValue = PTScaleSetting.widthScale
        if self.isExceptViewClass(exceptViews) {
            return
        }
        // 约束
        if types.contains(.constraint) {
            constraints.forEach {
                $0.constant *= scaleValue
            }
        }
        // 字体大小, 无法兼容attributeString
        if types.contains(.fontSize) {
            if let label = self as? UILabel {
                if label.superview?.isKind(of: UIButton.self) == false {
                    label.font = label.font.withSize(label.font.pointSize * scaleValue)
                }
            } else if let textField = self as? UITextField {
                if var fontSize = textField.font?.pointSize {
                    fontSize *= scaleValue
                    textField.font = textField.font?.withSize(fontSize)
                }
            } else if let button = self as? UIButton {
                if var fontSize = button.titleLabel?.font.pointSize {
                    fontSize *= scaleValue
                    button.titleLabel?.font = button.titleLabel?.font?.withSize(fontSize)
                }
            } else if let textView = self as? UITextView {
                if var fontSize = textView.font?.pointSize {
                    fontSize *= scaleValue
                    textView.font = textView.font?.withSize(fontSize)
                }
            }
        }
        
        // 圆角
        if types.contains(.cornerRadius), layer.cornerRadius != 0 {
            layer.cornerRadius = layer.cornerRadius * scaleValue
        }
        
        if isScaleSubViews {
            // 递归subViews
            subviews.forEach {
                $0.scale(types: types, isScaleSubViews: isScaleSubViews, exceptViews: exceptViews)
            }
        }
        
    }
    /// 当前view对象是否是例外的视图
    func isExceptViewClass(_ classArray: [AnyObject]?) -> Bool {
        var isExcept = false
        if let classArray = classArray {
            for item in classArray {
                if isKind(of: type(of: item)) {
                    isExcept = true
                }
            }
        }
        return isExcept
    }
    /// 移除渐变层
    func removeGradientLayer() {
        layer.sublayers?.forEach {
            if $0.isKind(of: CAGradientLayer.self) {
                $0.removeFromSuperlayer()
            }
        }
    }
    /// 获取视图相对于window的位置
    func rectFromWindow() -> CGRect {
        guard let window = UIApplication.shared.delegate?.window else {
            debugPrint("获取window失败")
            return CGRect.zero
        }
        let rect = convert(bounds, to: window)
        return rect
    }
    /// UIView Convert To Image
    func toUIImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    /// 画线
    private func drawBorder(rect: CGRect,color: UIColor){
        let line = UIBezierPath(rect: rect)
        let lineShape = CAShapeLayer()
        lineShape.path = line.cgPath
        lineShape.fillColor = color.cgColor
        //        self.layer.addSublayer(lineShape)
        layer.insertSublayer(lineShape, at: 0)
    }
    /// 绘制边框
    /// - Parameters:
    ///   - direction: 边框方向
    ///   - borderColor: 边框颜色
    ///   - width: direction为top和bottom时， 边框线长度，默认frame.size.width；direction为left和right的时候，边框线宽度，默认1.0
    ///   - height: direction为top和bottom时， 边框线宽度，默认1.0；direction为left和right的时候，边框线长度，默认frame.size.height
    func border(direction: BorderDirection, borderColor: UIColor, width: CGFloat? = nil, height: CGFloat? = nil) {
        var rect: CGRect
        switch direction {
        case .top:
            rect = CGRect(x: 0, y: 0, width: width ?? frame.size.width, height: height ?? 1.0)
        case .bottom:
            rect = CGRect(x: 0, y: frame.size.height - (height ?? 1.0), width: width ?? frame.size.width, height: height ?? 1.0)
        case .left:
            rect = CGRect(x: 0, y: 0, width: width ?? 1.0, height: height ?? frame.size.height)
        case .right:
            rect = CGRect(x: frame.size.width - (width ?? 1.0), y: 0, width: width ?? 1.0, height: height ?? frame.size.height)
        }
        drawBorder(rect: rect, color: borderColor)
    }
    /// 设置任意角圆角
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    /// SwifterSwift: Add shadow to view.
    ///
    /// - Note: This method only works with non-clear background color, or if the view has a `shadowPath` set.
    /// See parameter `opacity` for detail.
    ///
    /// - Parameters:
    ///   - color: shadow color (default is #137992).
    ///   - radius: shadow radius (default is 3).
    ///   - offset: shadow offset (default is .zero).
    ///   - opacity: shadow opacity (default is 0.5). It will also be affected by the `alpha` of `backgroundColor`
    func addShadow(
        ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0),
        radius: CGFloat = 3,
        offset: CGSize = .zero,
        opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    /// SwifterSwift: Add array of subviews to view.
    ///
    /// - Parameter subviews: array of subviews to add to self.
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
}
