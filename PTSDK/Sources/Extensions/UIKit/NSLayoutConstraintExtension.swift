//
//  NSLayoutConstraintExtension.swift
//  PTSDK
//
//  Created by PainTypeZ on 2020/12/29.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public extension NSLayoutConstraint {
    /// 修改multiplier, 原理是替换一个新的约束进去
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        guard let firstItem = firstItem else {
            debugPrint("firstItem不存在")
            return self
        }
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
