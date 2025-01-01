//
//  UIImagePickerController+Combine.swift
//  Pods
//
//  Created by dzb0409 on 2024/12/23.
//

#if canImport(Combine)

import UIKit
import Combine

@available(iOS 13.0, *)
extension UIImagePickerController: LCombineXCompatible { }

private func dismissViewController(_ viewController: UIViewController, animated: Bool) {
    if viewController.isBeingDismissed || viewController.isBeingPresented {
        DispatchQueue.main.async {
            dismissViewController(viewController, animated: animated)
        }

        return
    }

    if viewController.presentingViewController != nil {
        viewController.dismiss(animated: animated, completion: nil)
    }
}

@available(iOS 13.0, *)
extension LCombineXWrapper where Base: UIImagePickerController {
    private var delegate: ImagePickerControllerDelegate {
        return .proxy(for: base,
                      setter: #selector(setter: self.base.delegate),
                      getter: #selector(getter: self.base.delegate))
    }
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didFinishPickingMediaWithInfo: AnyPublisher<[UIImagePickerController.InfoKey : AnyObject], Never> {
        let selector = #selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:))
        return self.delegate.intercept(selector).map { values in
           values[1] as? [UIImagePickerController.InfoKey : AnyObject] ?? [:]
        }.eraseToAnyPublisher()
    }

    /**
     Reactive wrapper for `delegate` message.
     */
    public var didCancel: AnyPublisher<Void, Never> {
        let selector = #selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:))
        return self.delegate.intercept(selector).eraseToAnyPublisher()
    }
        
    /// 静态方法创建ImagePicker控制器
    /// - Parameters:
    ///   - parent: 父控制器
    ///   - animated: 动画
    ///   - configureImagePicker: 外部配置imagePicker参数
    /// - Returns: AnyPublisher
    public static func createWithParent(_ parent: UIViewController?, animated: Bool = true, configureImagePicker: @escaping (UIImagePickerController) throws -> Void = { x in }) -> AnyPublisher<[UIImagePickerController.InfoKey : Any], Error> {
        AnyPublisher.create { subscriber in
            let imagePicker = UIImagePickerController()
            let dismissDisposable = imagePicker.lx.didCancel.sink {  _ in
                subscriber.send(completion: .finished)
            }
            
            let finishDisposable = imagePicker.lx.didFinishPickingMediaWithInfo.sink { info in
                subscriber.send(info)
                subscriber.send(completion: .finished)
            }
            
            do {
                try configureImagePicker(imagePicker)
            } catch let error {
                subscriber.send(completion: .failure(error))
                return AnyCancellable {
                    finishDisposable.cancel()
                    dismissDisposable.cancel()
                    dismissViewController(imagePicker, animated: animated)
                }
            }
            
            guard let parent = parent else {
                subscriber.send(completion: .finished)
                return AnyCancellable {
                    finishDisposable.cancel()
                    dismissDisposable.cancel()
                }
            }
            parent.present(imagePicker, animated: animated, completion: nil)
            
            return AnyCancellable {
                finishDisposable.cancel()
                dismissDisposable.cancel()
                dismissViewController(imagePicker, animated: animated)
            }
        }
    }
}

@available(iOS 13.0, *)
private class ImagePickerControllerDelegate: DelegateProxy<UIImagePickerControllerDelegate>, UIImagePickerControllerDelegate {
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        forwardee?.imagePickerControllerDidCancel?(picker)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        forwardee?.imagePickerController?(picker, didFinishPickingMediaWithInfo: info)
    }
}

#endif
