//
//  PTProtocol.swift
//  PTPackage
//
//  Created by PainTypeZ on 2020/11/16.
//

import Foundation

/// 获取类型名
public protocol PTNamable {
    static var typeName: String { get }
    var typeName: String { get }
}

public extension PTNamable {
    static var typeName: String {
        return String(describing: self)
    }
    var typeName: String {
        return String(describing: type(of: self))
    }
}
/// Nib加载的view
public protocol PTNibLoadable: AnyObject, PTNamable {
    static var nibName: String { get }
    static func loadFromNib() -> Self
}
public extension PTNibLoadable where Self: UIView {
    static var nibName: String {
        return Self.typeName
    }

    static func loadFromNib() -> Self {
        guard let view = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as? Self else {
            fatalError("Could not load nib file with Type:\(nibName)")
        }
        return view
    }
}

/// 可重用的view
public protocol PTReusableView: AnyObject, PTNamable {
    static var defaultReuseIdentifier: String { get }
}

public extension PTReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return Self.typeName
    }
}

/// cell相关简化API
public protocol PTRegisterCell {

}
public extension PTRegisterCell where Self: UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: PTReusableView {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    func register<T: UITableViewCell>(_: T.Type) where T: PTReusableView, T: PTNibLoadable {
        let nib = UINib(nibName: T.nibName, bundle: Bundle(for: T.self))
        register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: PTReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}
public extension PTRegisterCell where Self: UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: PTReusableView {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    func register<T: UICollectionViewCell>(_: T.Type) where T: PTReusableView, T: PTNibLoadable {
        let nib = UINib(nibName: T.nibName, bundle: Bundle(for: T.self))
        register(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: PTReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}

extension UITableView: PTRegisterCell {

}

extension UICollectionView: PTRegisterCell {

}

/// 在viewController的viewWillAppear调用addKeyboardObserve，viewWillDisappear调用removeKeyboardObserve，
/// 键盘观察，可以尽量使用静态tableView来减少此协议的使用率。。。。。
public protocol PTKeyboardObserve: UIViewController {
    // 输入视图所在滚动的引用
    var inputScrollView: UIScrollView? { get set }
    // 第一响应者的引用
    var activeInputView: UIView? { get set }
}

public extension PTKeyboardObserve {
    /// 观察键盘
    func addKeyboardObserve(scrollView: UIScrollView) {
        inputScrollView = scrollView
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                               object: nil,
                                               queue: nil) { [weak self] notification in
            self?.keyboardWillShowNotification(notification: notification)
        }
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                               object: nil,
                                               queue: nil) { [weak self] notification in
            self?.keyboardWillHideNotification(notification: notification)
        }
    }
    /// 移除键盘观察
    func removeKeyboardObserve() {
        inputScrollView = nil
        activeInputView = nil
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    /// 键盘显示时的处理
    private func keyboardWillShowNotification(notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        inputScrollView?.contentInset = contentInsets
        inputScrollView?.scrollIndicatorInsets = contentInsets
        if let activeInputView = activeInputView, let inputScrollView = inputScrollView {
            let rect = activeInputView.convert(activeInputView.frame, from: inputScrollView)
            let textFieldBottomPoint = abs(rect.origin.y) + activeInputView.frame.size.height
            let keyboardEndPoint = inputScrollView.frame.height - keyboardSize.height

            if keyboardEndPoint <= textFieldBottomPoint {
                inputScrollView.contentOffset.y = textFieldBottomPoint - keyboardEndPoint
            } else {
                inputScrollView.contentOffset.y = 0
            }
        }
    }
    /// 键盘收起时的处理
    private func keyboardWillHideNotification(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        inputScrollView?.contentInset = contentInsets
        inputScrollView?.scrollIndicatorInsets = contentInsets
    }
}

/// 注册观察者组件
public protocol PTRegisterObserver {

}

public extension PTRegisterObserver {
    func registerToDefaultNotificationCenter(notificationName: String,
                                             selector: Selector,
                                             object: AnyObject? = nil) {
        let name = Notification.Name(notificationName)
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: object)
    }
    func registerToDefaultNotificationCenter(notificationName: Notification.Name,
                                             selector: Selector,
                                             object: AnyObject? = nil) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notificationName, object: object)
    }
    func registerToDefaultNotificationCenter<T: PTNotificationName>(notificationName: T,
                                                                    selector: Selector,
                                                                    object: AnyObject? = nil) {
        let name = notificationName.notificationName
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: object)
    }
    func removeObserverFromDefaultNotificationCenter() {
        NotificationCenter.default.removeObserver(self)
    }
}
/// 发送通知组件
public protocol PTPostNotification {

}

public extension PTPostNotification {
    func postNotification(name: String, object: Any? = nil, userInfo: [String: Any]? = nil) {
        NotificationCenter.default.post(name: NSNotification.Name(name), object: object, userInfo: userInfo)
    }
    func postNotificationThroughDefaultCenter(notificationName: Notification.Name,
                                              object: Any? = nil,
                                              userInfo: [String: Any]? = nil) {
        NotificationCenter.default.post(name: notificationName, object: object, userInfo: userInfo)
    }
    func postNotificationThroughDefaultCenter<T: PTNotificationName>(notificationName: T,
                                                                     object: Any? = nil,
                                                                     userInfo: [String: Any]? = nil) {
        NotificationCenter.default.post(name: notificationName.notificationName, object: object, userInfo: userInfo)
    }
}
/// 通知名称组件
public protocol PTNotificationName: PTNamable {
    // 通知名字符串
    var notificationNameString: String { get }
    // 通知名
    var notificationName: Notification.Name { get }
}
