//
//  UIViewControllerExtension.swift
//  PTTools
//
//  Created by PainTypeZ on 2020/12/22.
//

import UIKit

// MARK: - Properties
public extension UIViewController {
    /// 是否可见
    var isVisible: Bool {
        // http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
        return isViewLoaded && view.window != nil
    }
}
// MARK: - Methods
public extension UIViewController {
    /// 进入某个VC
    /// - Parameters:
    ///   - target: 目标控制器
    ///   - isConfirmPresent: 是否强制present
    func enter(_ target: UIViewController?, isConfirmPresent: Bool = false) {
        guard let target = target else {
            return
        }
        guard isConfirmPresent == false else {
            target.modalPresentationStyle = .fullScreen
            present(target, animated: true, completion: nil)
            return
        }
        if let navigationController = navigationController {
            navigationController.pushViewController(target, animated: true)
        } else {
            target.modalPresentationStyle = .fullScreen
            present(target, animated: true, completion: nil)
        }
    }
    /// 关闭界面
    func close() {
        if let navigationController = navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    /// 简易警告消息弹窗
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 内容
    ///   - confirmHandler: 点击确定后的回调
    func alert(title: String, message: String, confirmHandler: @escaping (UIAlertAction) -> Void) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "确定", style: .default, handler: confirmHandler)
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(confirmAction)
        present(alertViewController, animated: true, completion: nil)
    }
    /// 相机/相册警告窗
    /// - Parameters:
    ///   - title: 标题
    ///   - delegate:  代理
    ///   - viewController: 处理弹窗的视图控制器
    func showPhotoAlertSheetAtBottom(title: String,
                                     delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate,
                                     viewController: UIViewController) {
        let alertController = UIAlertController.init(title: title, message: "从相册选择或拍照", preferredStyle: .actionSheet)
        let openCameraAction = UIAlertAction.init(title: "拍照", style: .default) { [weak self] _ in
            self?.openCamera(delegate: delegate, viewController: viewController)
        }
        let openPhotoAction = UIAlertAction.init(title: "从相册选择", style: .default) { [weak self] _ in
            self?.openPhotoAlbum(delegate: delegate, viewController: viewController)
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(openCameraAction)
        alertController.addAction(openPhotoAction)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    /// 打开相册
    /// - Parameters:
    ///   - delegate: 代理
    ///   - viewController: 处理弹窗的视图控制器
    func openPhotoAlbum(delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate),
                        viewController: UIViewController) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = delegate
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            viewController.present(imagePicker, animated: true, completion: nil)
        } else {
            print("打开相册失败")
        }
    }
    /// 打开相机
    /// - Parameters:
    ///   - delegate: 代理
    ///   - viewController: 处理弹窗的视图控制器
    func openCamera(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate,
                    viewController: UIViewController) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = delegate
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            viewController.present(imagePicker, animated: true, completion: nil)
        } else {
            print("打开相机失败")
        }
    }
}
