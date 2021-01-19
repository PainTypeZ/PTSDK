//
//  SelectItemButton.swift
//  SelectedItemGroup
//
//  Created by Pengpingjun on 2020/12/3.
//

import UIKit
/// 自定义按钮状态
public enum SelectItemButtonState {
    /// 对应UIControl的normal状态
    case normal
    /// 对应UIControl的selectd状态，包括disable+selected的状态
    case selected
    /// 对应UIControl的disable状态
    case disabled
}
/// UI事件代理
public protocol SelectItemButtonDelegate: AnyObject {
    /// 按钮点击
    /// - Parameter tag: button的tag
    func didTapped(tag: Int)
}
/// 方便处理可选状态的button
public class SelectItemButton: UIButton, PTSelectableItem {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addTappedEvent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        addTappedEvent()
    }
    
    public override var isSelected: Bool {
        didSet {
            handleStateChange()
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            handleStateChange()
        }
    }
    /// 解决tap时高亮文字颜色自动切换问题
    public override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = false
        }
    }
    
    /// 选中时边框颜色
    @IBInspectable
    private var selectedBorderColor: UIColor?
    /// 选中时背景颜色
    @IBInspectable
    private var selectedBackgroundColor: UIColor?
    
    /// 不可用时边框颜色
    @IBInspectable
    private var disabledBorderColor: UIColor?
    /// 不可用时背景颜色
    @IBInspectable
    private var disabledBackgroundColor: UIColor?
    
    /// 普通状态边框颜色
    @IBInspectable
    private var normalBorderColor: UIColor?
    /// 普通状态背景颜色
    @IBInspectable
    private var normalBackgroundColor: UIColor?
    
    /// 自定义状态
    private(set) var customState: SelectItemButtonState = .normal {
        didSet {
            switch customState {
            case .normal:
                layer.borderColor = normalBorderColor?.cgColor
                backgroundColor = normalBackgroundColor
            case .selected:
                layer.borderColor = selectedBorderColor?.cgColor
                backgroundColor = selectedBackgroundColor
            case .disabled:
                layer.borderColor = disabledBorderColor?.cgColor
                backgroundColor = disabledBackgroundColor
            }
        }
    }
    
    /// 代理
    weak var delegate: SelectItemButtonDelegate?
    
    /// 设置UI属性
    private func setupUI() {
        layer.borderWidth = 1.0
        adjustsImageWhenHighlighted = false
        adjustsImageWhenDisabled = false
    }
    
    /// 添加点击事件
    private func addTappedEvent() {
        addTarget(nil, action: #selector(didTapped(sender:)), for: .touchUpInside)
    }
    
    /// 处理点击事件
    /// - Parameter sender: 被点击的button
    @objc private func didTapped(sender: SelectItemButton) {
        // 发送代理消息
        delegate?.didTapped(tag: tag)
    }

    /// 处理状态变化
    private func handleStateChange() {
        switch (isSelected, isEnabled) {
        case (true, true):
            customState = .selected
        case (true, false):
            customState = .selected
        case (false, true):
            customState = .normal
        case (false, false):
            customState = .disabled
        }
    }
    
    /// 设置自定义状态边框颜色
    /// - Parameters:
    ///   - color: 边框颜色
    ///   - state: 自定义状态
    func setBoarderColor(_ color: UIColor, for state: SelectItemButtonState) {
        switch state {
        case .normal:
            normalBorderColor = color
            layer.borderColor = normalBorderColor?.cgColor
        case .selected:
            selectedBorderColor = color
        case .disabled:
            disabledBorderColor = color
        }
    }
    
    /// 设置自定义状态背景色
    /// - Parameters:
    ///   - color: 背景颜色
    ///   - state: 自定义状态
    func setBackgroundColor(_ color: UIColor, for state: SelectItemButtonState) {
        switch state {
        case .normal:
            normalBackgroundColor = color
            backgroundColor = normalBackgroundColor
        case .selected:
            selectedBackgroundColor = color
        case .disabled:
            disabledBackgroundColor = color
        }
    }
}
