////
////  ImagePicker.swift
//
//import UIKit
//
//protocol ImagePickerProtocol {
//	var preparedImage: UIImage? { get }
//	func showImagePicker(sourseType: UIImagePickerController.SourceType, completion: ((UIImage) -> Void)?)
//}
//
//final class ImagePicker: NSObject, ImagePickerProtocol {
//	
//	private lazy var ImagePicker: UIImagePickerController = {
//		let pickerView = UIImagePickerController()
//		pickerView.delegate = self
//		return pickerView
//	}()
//	
//	private let parentViewController: UIViewController
//	private var onPreparedImage: ((UIImage) -> Void)?
//	
//	var preparedImage: UIImage?
//	
//	init(parentViewController: UIViewController) {
//		self.parentViewController = parentViewController
//	}
//	
//	func showImagePicker(sourseType: UIImagePickerController.SourceType, completion: ((UIImage) -> Void)?) {
//		onPreparedImage = completion
//		ImagePicker.sourceType = sourseType
//		parentViewController.present(ImagePicker, animated: true)
//	}	
//}
//
//extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//		guard let image = info[.originalImage] as? UIImage else { return }
//		picker.dismiss(animated: true) { [weak self] in
//			self?.onPreparedImage?(image)
//			self?.preparedImage = image
//		}
//	}
//}

import UIKit
import PhotosUI

protocol ImagePHPickerProtocol {
	var preparedImage: UIImage? { get }
	func showImagePicker(filter: PHPickerFilter, completion: ((UIImage) -> Void)?)
}

final class ImagePHPicker: NSObject, ImagePHPickerProtocol {

	private let parentViewController: UIViewController
	private var onPreparedImage: ((UIImage) -> Void)?

	var preparedImage: UIImage?

	init(parentViewController: UIViewController) {
		self.parentViewController = parentViewController
		super.init()
	}

	func showImagePicker(filter: PHPickerFilter ,completion: ((UIImage) -> Void)?) {
		onPreparedImage = completion

		var configuration = PHPickerConfiguration()
		configuration.selectionLimit = 1 // Ограничение на выбор одного изображения
		configuration.filter = filter // Фильтр для выбора только изображений

		let picker = PHPickerViewController(configuration: configuration)
		picker.delegate = self // Устанавливаем делегат

		parentViewController.present(picker, animated: true)
	}
}

// MARK: - PHPickerViewControllerDelegate

extension ImagePHPicker: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		picker.dismiss(animated: true) { [weak self] in
			// Обработка выбранных медиа
			for result in results {
				if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
					result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
						DispatchQueue.main.async {
							if let image = image as? UIImage {
								self?.preparedImage = image
								self?.onPreparedImage?(image)
							}
						}
					}
				}
			}
		}
	}
}
