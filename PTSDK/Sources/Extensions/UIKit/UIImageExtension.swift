//
//  UIImageExtension.swift
//  PTSDK
//
//  Created by PainTypeZ on 2020/12/29.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public extension UIImage {
    /// 绘制纯色图片
    static func getImage(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// ReDraw UIImage To NewUIImage With Size
    func newSizeUIImage(size:CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let cgContext:CGContext = UIGraphicsGetCurrentContext()!
        cgContext.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    /// 绘制圆角
    func drawCornerRadiusImage(rect:CGRect? = nil, radius:CGFloat? = nil) -> UIImage? {
        UIGraphicsBeginImageContext(rect?.size ?? self.size)
        var path:UIBezierPath
        let width = min(self.size.width, self.size.height)
        if let radius = radius {
            path = UIBezierPath(roundedRect:rect ?? CGRect(x: 0, y: 0, width: width, height: width), cornerRadius: radius)
            path.addClip()
            draw(in: rect ?? CGRect(x: 0, y: 0, width: width, height: width))
        } else {
            path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: width, height: width))
            path.addClip()
            draw(at: CGPoint.zero)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
