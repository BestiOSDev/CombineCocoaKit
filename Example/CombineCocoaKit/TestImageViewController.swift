//
//  TestImageViewController.swift
//  LCombineExtension_Example
//
//  Created by dzb0409 on 2024/12/17.
//

import UIKit
import Combine
import SnapKit
import CombineCocoaKit

class TestImageViewController: UIViewController {
    private lazy var cancellables: Set<AnyCancellable> = []
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TestImageViewController"
        self.view.backgroundColor = .white
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 300, height: 300))
        }
        downloadImage()
            .handleEvents(receiveSubscription: { subscription in
                print("Receive subscription: \(subscription)")
            }, receiveOutput: { image in
                print("receiveOutput: \(image)")
            }, receiveCompletion: {
                print("Receive completion: \($0)")
            }, receiveCancel: {
                print("Receive cancel")
            }, receiveRequest: {
                print("Receive request: \($0)")
            })
            .bind(to: self.imageView.lx.image)
            .store(in: &cancellables)
    }
    
    /// 模拟网络请求下载图片，并给imageView.image赋值
    private func downloadImage() -> AnyPublisher<UIImage?, Never> {
        return AnyPublisher.create { subscriber in
            let url = URL(string: "http://gips2.baidu.com/it/u=195724436,3554684702&fm=3028&app=3028&f=JPEG&fmt=auto?w=1280&h=960")!
            let dataPublisher = URLSession.shared.dataTaskPublisher(for: url).receive(on: DispatchQueue.main)
            let subscription = dataPublisher.sink { _ in
                subscriber.send(completion: .finished)
            } receiveValue: { (data: Data, response: URLResponse) in
                let image = UIImage(data: data)
                subscriber.send(image)
            }
            return AnyCancellable {
                subscription.cancel()
            }
        }
    }
    
}
