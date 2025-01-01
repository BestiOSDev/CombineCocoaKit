//
//  TestPublisherViewController.swift
//  LCombineExtension_Example
//
//  Created by dzb0409 on 2024/12/19.
//

import UIKit
import CombineCocoaKit

// MARK: - `Hashable`-related tests

struct Student: Equatable, CustomDebugStringConvertible {
    var debugDescription: String {
        return "name:\(name), score:\(score)"
    }
    var name: String = ""
    var id: String = UUID().uuidString
    var score: Int = Int.random(in: 0...100)
    init(name: String, score: Int) {
        self.name = name
        self.score = score
    }
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name && lhs.score == rhs.score
    }
}

private struct HashableFour: Hashable {
    static let one = HashableFour(1)
    static let two = HashableFour(2)
    static let three = HashableFour(3)
    static let four = HashableFour(4)
    
    private let underlying: Int
    
    private init(_ underlying: Int) { self.underlying = underlying }
}

class TestPublisherViewController: UIViewController {
    @Published var userName: String? = ""
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var cancelables: [AnyCancellable] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Combine"
        self.view.backgroundColor = .white
//      testCurrentValeRelay()
//      testPassthroughRelay()
//        testRelaySubject()
//        testZipOperator()
//        testCombineLatestOperator()
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(50.0)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        testAssignOperator()
        testRemoveDuplicates()
        testCreateOperator()
    }
    /*
     封装单个值并在值更改时发布新元素的中继。
     与其对应的主题不同，它可能只接受值，并且只在释放时发送一个完成事件。
     它不能发送失败事件。
     注意：与 PassthroughRelay 不同，CurrentValueRelay 维护最近发布的值的缓冲区。
     功能和 Combine.CurrentValueSubject 形似, 唯一区别是不能发送 Failure 事件, 相当于
     CurrentValueSubject<Output, Never>
     */
    func testCurrentValeRelay() {
        let relay = CurrentValueRelay(value: "🔴")
        // 当subscriber1订阅时， relay 会发送默认元素 🔴。
        let subscriber1 = relay.sink { value in
            print("subscriber1 \(value)")
        }
        relay.accept("🐶")
        relay.accept("🐱")
        // 当subscriber2 订阅时, relay 会把最新元素 🐱 发送出来。
        let subscriber2 = relay.sink { value in
            print("subscriber2 \(value)")
        }
        
        subscriber2.cancel()
        relay.accept("🐷")
        subscriber1.cancel()
        // 此时 relay 发送数据 不会被任何订阅者接收到。
        relay.accept("🐴")
    }
    /*
     向下游订阅者广播值的中继。
     与其对应的主题不同，它可能只接受值，并且只在释放时发送一个完成事件。
     它不能发送失败事件。
      注意：与 CurrentValueRelay 不同，PassthroughRelay 没有初始值或最近发布值的缓冲区。
     功能和 Combine.PassthroughSubject 形似, 唯一区别是不能发送 Failure 事件, 相当于
     PassthroughSubject<Output, Never>
     */
    func testPassthroughRelay() {
        let relay = PassthroughRelay<String>()
        let subscriber1 = relay.sink { value in
            print("subscriber1 \(value)")
        }
        relay.accept("🐶")
        let subscriber2 = relay.sink { value in
            print("subscriber2 \(value)")
        }
        relay.accept("🐱")
        subscriber2.cancel()
        relay.accept("🐷")
        subscriber1.cancel()
        relay.accept("🐴")
    }
    
    /*
     ReplaySubject 将对观察者发送全部的元素，无论观察者是何时进行订阅的。
     ReplaySubject 内部是一个数组保存了所有发送出去的元素, 当超过最大缓存数量后会移除第一个元素
     功能和 Rxswift.ReplaySubject 是一模一样的
     */
    
    func testRelaySubject() {
        // 设置缓冲区元素个数为2个 超过2个时，只会保留最新的2元素数据。
        let subject = CombineCocoaKit.ReplaySubject<String, Never>.init(bufferSize: 2)
        let subscriber1 = subject.sink { str in
          print("Subscription: 1 Event:", str)
        }
        subject.send("🐶")
        subject.send("🐱")
        let subscriber2 = subject.sink { str in
          print("Subscription: 2 Event:", str)
        }
        // subscriber1 取消订阅，它将会接收到 🐶 🐱
        subscriber1.cancel()
        subject.send("🅰️")
        subject.send("🅱️")
        // subscriber2 取消订阅，它将会接收到 🐶 🐱 🅰️ 🅱️
        subscriber2.cancel()
        subject.send("❎")
        let subscriber3 = subject.sink { str in
          print("Subscription: 3 Event:", str)
        }
        subject.send("🚗")
        // subscriber3 取消订阅，它将会接收到  🅱️ ❎ 🚗
        subscriber3.cancel()
        // 此时订阅者 subscriber4 它将会收到  ❎ 🚗
        let subscriber4 = subject.sink { str in
            print("Subscription: 4 Event:", str)
        }
        subscriber4.cancel()
    }
    
    func testZipOperator() {
        let subject1 = CombineCocoaKit.CurrentValueRelay<Int>(value: 0)
        let subject2 = CombineCocoaKit.CurrentValueRelay<Int>(value: 1)
        let subject3 = CombineCocoaKit.CurrentValueRelay<Int>(value: 2)
        let subject4 = CombineCocoaKit.CurrentValueRelay<Int>(value: 3)
        let subject5 = CombineCocoaKit.CurrentValueRelay<Int>(value: 4)
//        subject1.zip(subject2).sink { (a, b) in
//            debugPrint("Subscription1: a = \(a), b = \(b)")
//        }.store(in: &cancelables)
        subject1.l_zip(with: [subject2, subject3, subject4, subject5]).sink { values in
            debugPrint("Subscription1: \(values)")
        }.store(in: &cancelables)
//        
        subject1.accept(5)
        subject2.accept(6)
        subject3.accept(7)
        subject4.accept(8)
        subject5.accept(9)
    }
    
    func testCombineLatestOperator() {
        let subject1 = CombineCocoaKit.CurrentValueRelay<Int>(value: 0)
        let subject2 = CombineCocoaKit.CurrentValueRelay<Int>(value: 1)
        let subject3 = CombineCocoaKit.CurrentValueRelay<Int>(value: 2)
        let subject4 = CombineCocoaKit.CurrentValueRelay<Int>(value: 3)
        let subject5 = CombineCocoaKit.CurrentValueRelay<Int>(value: 4)
        [subject1, subject2, subject3, subject4, subject5].combineLatest().sink { _ in
            
        } receiveValue: { results in
            debugPrint("a = \(results[0]), b = \(results[1]), c = \(results[2]), d = \(results[3]), e = \(results[4])")
        }.store(in: &cancelables)

        subject1.accept(5)
        subject2.accept(6)
        subject3.accept(7)
        subject4.accept(8)
        subject5.accept(9)
        /*
         "a = 0, b = 1, c = 2, d = 3, e = 4"
         "a = 5, b = 1, c = 2, d = 3, e = 4"
         "a = 5, b = 6, c = 2, d = 3, e = 4"
         "a = 5, b = 6, c = 7, d = 3, e = 4"
         "a = 5, b = 6, c = 7, d = 8, e = 4"
         "a = 5, b = 6, c = 7, d = 8, e = 9"
         */
    }
    
    func testAssignOperator() {
        let subject = PassthroughSubject<String?, Never>.init()
        subject.l_assign2(to: \.text, on: self.nameLabel, and: \.title, on: self).store(in: &cancelables)
        subject.send("Hello World")
        subject.send("Again")
        
        $userName.l_assign2(to: \.text, on: self.nameLabel, and: \.title, on: self).store(in: &cancelables)
        userName = "Hello World"
        
    }
    
    func testRemoveDuplicates() {
        let student1 = Student(name: "John", score: 20)
        let student2 = Student(name: "David", score: 30)
        let student3 = Student(name: "Bryant", score: 40)
        let student4 = Student(name: "Kobe", score: 50)
        let student5 = Student(name: "James", score: 60)
        let student6 = Student(name: "John", score: 20)
        let student7 = Student(name: "John", score: 20)
        // 数组元素不会去重
        [student1, student2, student3, student4, student5, student6].publisher.removeDuplicates().sink { (student) in
            debugPrint("student = \(student)")
        }.store(in: &cancelables)
        debugPrint("----------------------------")
        // 数组元素会去重复
        [student1, student2, student3, student4, student5, student6].publisher.removeAllDuplicates().sink { (student) in
            debugPrint("student = \(student)")
        }.store(in: &cancelables)
        debugPrint("----------------------------")

        let subject = CurrentValueSubject<Student, Never>.init(student1)
        subject
            .removeAllDuplicates()
            .sink { student in
            debugPrint("student = \(student)")
        }.store(in: &cancelables)
        subject.send(student2)
        subject.send(student3)
        subject.send(student4)
        subject.send(student5)
        subject.send(student6)
        subject.send(student7)
    }
    
    func testCreateOperator() {
        getImageDownloadUrl()
            .flatMap { url in
                self.downloadImage(with: url)
            }
            .bind(to: self.imageView.lx.image)
            .store(in: &cancelables)
//            .sink { _ in
//                debugPrint("下载完成")
//            } receiveValue: {[weak self] image in
//                self?.imageView.image = image
//            }.store(in: &cancelables)
    }
    
    /// 模拟网络请求 获取下载url
    private func getImageDownloadUrl() -> AnyPublisher<String, Never> {
        return AnyPublisher.create { subscriber in
            subscriber.send("http://gips2.baidu.com/it/u=195724436,3554684702&fm=3028&app=3028&f=JPEG&fmt=auto?w=1280&h=960")
            subscriber.send(completion: .finished)
            return AnyCancellable {}
        }
    }
    
    /// 根据url下载图片
    private func downloadImage(with imageUrl: String) -> AnyPublisher<UIImage?, Never> {
        return AnyPublisher.create { subscriber in
            let url = URL(string: imageUrl)!
            let dataPublisher = URLSession.shared.dataTaskPublisher(for: url).receive(on: DispatchQueue.main)
            let subscription = dataPublisher.sink { _ in
                subscriber.send(completion: .finished)
            } receiveValue: { (data: Data, _: URLResponse) in
                let image = UIImage(data: data)
                subscriber.send(image)
            }
            return AnyCancellable {
                subscription.cancel()
            }
        }
    }
    
}
