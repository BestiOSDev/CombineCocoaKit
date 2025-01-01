//
//  ScrollViewTestViewController.swift
//  LCombineExtension_Example
//
//  Created by dzb0409 on 2024/12/17.
//

import UIKit
import Combine
import CombineCocoaKit

class ScrollViewTestViewController: UIViewController {

    private var cancellables: Set<AnyCancellable> = []
    private var yellowView: UIImageView = .init()

   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "ScrollViewTestViewController"

        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        scrollView.backgroundColor = .red
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1000)
        self.view.addSubview(scrollView)
        scrollView.frame = CGRect(x: 0.0, y: 100.0, width: self.view.frame.size.width, height: 600.0)
        
        scrollView.addSubview(yellowView)
        yellowView.backgroundColor = .yellow
        yellowView.frame = CGRect.init(x: 0.0, y: 0.0, width: scrollView.frame.width, height: 200.0)
        
        scrollView.lx.didScrollPublisher.sink {
            debugPrint("didScrollPublisher")
        }.store(in: &cancellables)
        
        scrollView.lx.willBeginDeceleratingPublisher.sink {
            debugPrint("willBeginDeceleratingPublisher")
        }.store(in: &cancellables)
        
        scrollView.lx.didEndDeceleratingPublisher.sink {
            debugPrint("didEndDeceleratingPublisher")
        }.store(in: &cancellables)
        
        scrollView.lx.didEndDraggingPublisher.sink { value in
            debugPrint("didEndDeceleratingPublisher \(value)")
        }.store(in: &cancellables)
        
        scrollView.lx.willBeginZoomingPublisher.sink { view in
            debugPrint("willBeginZoomingPublisher \(String(describing: view))")
        }.store(in: &cancellables)
        
        scrollView.lx.didZoomPublisher.sink { _ in
            debugPrint("didZoomPublisher ")
        }.store(in: &cancellables)
        
        scrollView.lx.didEndZooming.sink { _ in
            debugPrint("didEndZooming ")
        }.store(in: &cancellables)
        
        scrollView.lx.contentOffset.sink { value in
            debugPrint("contentOffset \(value)")
        }.store(in: &cancellables)
    }
    

}


extension ScrollViewTestViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        debugPrint("scrollViewDidScroll")
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        debugPrint("scrollViewWillBeginDecelerating")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        debugPrint("scrollViewDidEndDecelerating")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        debugPrint("scrollViewDidEndDragging \(decelerate)")
    }
    
    @objc func scrollViewDidZoom(_ scrollView: UIScrollView) {
        debugPrint("scrollViewDidZoom")
    }
    
    @objc func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        debugPrint("scrollViewDidScrollToTop")
    }
    
    @objc func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        debugPrint("scrollViewDidEndScrollingAnimation")
    }
    
    @objc func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        debugPrint("scrollViewWillBeginZooming")
    }
    
    @objc func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        debugPrint("scrollViewDidEndZooming")
    }
    
    @objc func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return yellowView
    }
    
}
