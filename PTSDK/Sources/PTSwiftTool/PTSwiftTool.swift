//
//  PTSwiftTool.swift
//  PTPackage
//
//  Created by PainTypeZ on 2020/11/16.
//

import Foundation

public struct PTSwiftTool {
    /// 单例
    static var shared = Self()
    private init() {

    }
    /// 退出App
    func exitApp() {
        guard let window = UIApplication.shared.delegate?.window else {
            exit(0)
        }
        
        UIView.animate(withDuration: 1) {
            window?.alpha = 0
            window?.frame = CGRect(x: UIScreen.main.bounds.width / 2,
                                   y: UIScreen.main.bounds.height / 2,
                                   width: 0,
                                   height: 0)
        } completion: { _ in
            exit(0)
        }
    }
    /// 获取app缓存大小
    func getCacheSize() -> String {
        let domain = FileManager.SearchPathDirectory.cachesDirectory
        let mask = FileManager.SearchPathDomainMask.userDomainMask
        if let cachePath = NSSearchPathForDirectoriesInDomains(domain, mask, true).first {
            if let fileArr = FileManager.default.subpaths(atPath: cachePath) {
                var size: Double = 0
                fileArr.forEach {
                    let path = (cachePath as NSString).appending("/\($0)")
                    if let floder = try? FileManager.default.attributesOfItem(atPath: path) {
                        floder.forEach {
                            if $0.key == FileAttributeKey.size {
                                size += ($0.value as AnyObject).doubleValue
                            }
                        }
                    } else {
                        print("floder获取失败")
                    }
                }
                let cache = size / 1024 / 1024
                return String(cache) + "MB"
            } else {
                print("fileArr获取失败")
                return ""
            }
        } else {
            print("cachePath获取失败")
            return ""
        }
    }
    /// 清除app缓存
    func clearAllCache() {
        let domain = FileManager.SearchPathDirectory.cachesDirectory
        let mask = FileManager.SearchPathDomainMask.userDomainMask
        if let cachePath = NSSearchPathForDirectoriesInDomains(domain, mask, true).first {
            if let fileArr = FileManager.default.subpaths(atPath: cachePath) {
                for file in fileArr {
                    let path = (cachePath as NSString).appending("/\(file)")
                    if FileManager.default.fileExists(atPath: path) {
                        do {
                            try FileManager.default.removeItem(atPath: path)
                        } catch let error {
                            print("FileManagerError: " + error.localizedDescription)
                        }
                    }
                }
            } else {
                print("fileArr获取失败")
            }
        } else {
            print("cachePath获取失败")
        }
    }
    /// 根据window获取顶层控制器
    func getCurrentViewController() -> (UIViewController?) {
        var window = UIApplication.shared.keyWindow
        // 是否为当前显示的window
        if window?.windowLevel != UIWindow.Level.normal {
            let windows = UIApplication.shared.windows
            for windowTemp in windows where windowTemp.windowLevel == .normal {
                window = windowTemp
            }
        }
        let rootVC = window?.rootViewController
        return getCurrentViewController(currentViewController: rootVC)
    }
    /// 根据控制器获取顶层控制器
    func getCurrentViewController(currentViewController: UIViewController?) -> UIViewController? {
        if currentViewController == nil {
            print("PTSwiftTool： 找不到顶层控制器")
            return nil
        }
        if let presentVC = currentViewController?.presentedViewController {
            // modal出来的 控制器
            return getCurrentViewController(currentViewController: presentVC)
        } else if let tabVC = currentViewController as? UITabBarController {
            // tabBar 的跟控制器
            if let selectVC = tabVC.selectedViewController {
                return getCurrentViewController(currentViewController: selectVC)
            }
            return nil
        } else if let naiVC = currentViewController as? UINavigationController {
            // 控制器是 nav
            return getCurrentViewController(currentViewController: naiVC.visibleViewController)
        } else {
            // 返回顶控制器
            return currentViewController
        }
    }
    /// 拨打电话
    func call(phoneNumber: String) -> Bool {
        let phoneURL = "tel://" + phoneNumber
        guard let url = URL(string: phoneURL) else {
            return false
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        return true
    }
}
