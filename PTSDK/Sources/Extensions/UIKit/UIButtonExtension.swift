//
//  UIButtonExtension.swift
//  PTSDK
//
//  Created by PainTypeZ on 2020/12/29.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public extension UIButton {
    /// 画线
    private func drawBorder(rect: CGRect,color: UIColor) {
        let line = UIBezierPath(rect: rect)
        let lineShape = CAShapeLayer()
        lineShape.path = line.cgPath
        lineShape.fillColor = color.cgColor
        layer.addSublayer(lineShape)
        //        layer.insertSublayer(lineShape, at: self.layer.sublayers?.count)
        //        self.layer.insertSublayer(lineShape, at: 0)
    }
    /// 添加底部居中边线，宽度同文本框
    func addBottomLineWithTitleWidth(lineWidth: CGFloat, borderColor: UIColor) {
        let rectWidth:CGFloat = titleLabel?.frame.width ?? 0
        let rect = CGRect(x: (frame.width - rectWidth) / 2,
                          y: self.frame.size.height - lineWidth,
                          width: rectWidth,
                          height: lineWidth)
        drawBorder(rect: rect, color: borderColor)
    }
    /// 添加底部变现，宽度同Button
    func addBottomLineWithButtonWidth(lineWidth: CGFloat, borderColor: UIColor) {
        let rectWidth:CGFloat = frame.width
        let rect = CGRect(x: (frame.width - rectWidth) / 2,
                          y: self.frame.size.height - lineWidth,
                          width: rectWidth,
                          height: lineWidth)
        drawBorder(rect: rect, color: borderColor)
    }
    /// 交换button和图片位置
    func exchangeTitleWithImage(_ titleToImageSpace: CGFloat?) {
        let labelWidth:CGFloat = titleLabel?.intrinsicContentSize.width ?? 0.0
        let imageWidth:CGFloat = imageView?.frame.size.width ?? 0.0
        var space:CGFloat = 0
        if let inputSpace = titleToImageSpace {
            space = inputSpace
        }
        titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -imageWidth - space, bottom: 0, right: imageWidth + space)
        imageEdgeInsets = UIEdgeInsets.init(top: 0, left: labelWidth + space, bottom: 0, right: -labelWidth - space)
    }
    /// 图片在上，文字在下
    func imageOnTheTopOfTitle(spacing:CGFloat = 0) {
        guard let pointSize = titleLabel?.font.pointSize else {
            return
        }
        let textSizeOptinal = titleLabel?.text?.size(withAttributes: [.font: UIFont.systemFont(ofSize: pointSize)])
        guard let imageSize = imageView?.frame.size,
              var titleSize = titleLabel?.frame.size,
              let textSize = textSizeOptinal else {
            return
        }
        let frameSize = textSize
        if titleSize.width + 0.5 < frameSize.width {
            titleSize.width = frameSize.width
        }
        let totalHeight = imageSize.height + titleSize.height + spacing
        imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - imageSize.height),
                                       left: 0,
                                       bottom: 0,
                                       right: -titleSize.width)
        titleEdgeInsets = UIEdgeInsets(top: 0,
                                       left: -imageSize.width,
                                       bottom: -(totalHeight - titleSize.height),
                                       right: 0)
    }
    
}
