//
//  ImagePickerController.swift
//  LCombineExtension_Example
//
//  Created by dzb0409 on 2024/12/23.
//

import UIKit
import SnapKit
import CombineCocoaKit

class ImagePickerController: UIViewController {
    private lazy var cancellables: Set<AnyCancellable> = []
    lazy var imageView: UIImageView = .init()
    lazy var cameraButton: UIButton = .init()
    lazy var galleryButton: UIButton = .init()
    lazy var cropButton: UIButton = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ImagePickerController"
        self.view.backgroundColor = .white
        
        self.view.addSubview(imageView)
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.snp.makeConstraints { make in
            make.height.equalTo(250.0)
            make.leading.trailing.equalToSuperview().inset(20.0)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        self.cameraButton.setTitleColor(.blue, for: .normal)
        self.cameraButton.setTitle("Camera", for: .normal)
        self.view.addSubview(cameraButton)
        cameraButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(30.0)
            make.top.equalTo(imageView.snp.bottom).offset(16.0)
        }
        
        self.galleryButton.setTitleColor(.blue, for: .normal)
        self.galleryButton.setTitle("Gallery", for: .normal)
        self.view.addSubview(galleryButton)
        galleryButton.snp.makeConstraints { make in
            make.height.equalTo(30.0)
            make.centerX.equalToSuperview()
            make.top.equalTo(cameraButton.snp.bottom).offset(16.0)
        }
        
        self.cropButton.setTitleColor(.blue, for: .normal)
        self.cropButton.setTitle("Crop", for: .normal)
        self.view.addSubview(cropButton)
        cropButton.snp.makeConstraints { make in
            make.height.equalTo(30.0)
            make.centerX.equalToSuperview()
            make.top.equalTo(galleryButton.snp.bottom).offset(16.0)
        }
     
        if #available(iOS 14.0, *) {
            galleryButton.lx.tapPublisher.sink {[weak self] _ in
                self?.addImagePicker(with: .photoLibrary, allowsEditing: false)
            }.store(in: &cancellables)
            cropButton.lx.tapPublisher.sink {[weak self] _ in
                self?.addImagePicker(with: .photoLibrary, allowsEditing: true)
            }.store(in: &cancellables)
            cameraButton.lx.tapPublisher.sink {[weak self] _ in
                self?.addImagePicker(with: .camera, allowsEditing: true)
            }.store(in: &cancellables)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    @available(iOS 14.0, *)
    private func addImagePicker(with sourceType: UIImagePickerController.SourceType, allowsEditing: Bool = false) {
        UIImagePickerController.lx.createWithParent(self, animated: true) { picker in
            picker.sourceType = sourceType
            picker.allowsEditing = allowsEditing
        }.map { info in
            info[.originalImage] as? UIImage
        }.sink { _ in
            
        } receiveValue: { image in
            self.imageView.image = image
        }.store(in: &self.cancellables)
    }
    
}
