//
//  ImagePicker.swift

import UIKit
import PhotosUI

protocol ImagePickerProtocol {
	var preparedImage: UIImage? { get }
	func showImagePicker(
		sourceType: UIImagePickerController.SourceType?,
		filter: PHPickerFilter?,
		completion: ((UIImage) -> Void)?
	)
}


final class ImagePicker: NSObject, ImagePickerProtocol {
	
	private lazy var imagePicker: UIImagePickerController = {
		let picker = UIImagePickerController()
		picker.delegate = self
		return picker
	}()
	
	private let parentViewController: UIViewController
	private var onPreparedImage: ((UIImage) -> Void)?
	
	var preparedImage: UIImage?
	
	init(parentViewController: UIViewController) {
		self.parentViewController = parentViewController
		super.init()
	}
	
	func showImagePicker(
		sourceType: UIImagePickerController.SourceType? = nil,
		filter: PHPickerFilter? = nil,
		completion: ((UIImage) -> Void)?
	) {
		onPreparedImage = completion
		
		if let sourceType = sourceType {
			imagePicker.sourceType = sourceType
			parentViewController.present(imagePicker, animated: true)
		} else if let filter = filter {
			var configuration = PHPickerConfiguration()
			configuration.selectionLimit = 1
			configuration.filter = filter
			let picker = PHPickerViewController(configuration: configuration)
			picker.delegate = self
			parentViewController.present(picker, animated: true)
		}
	}
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(
		_ picker: UIImagePickerController,
		didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
	) {
		guard let image = info[.originalImage] as? UIImage else { return }
		picker.dismiss(animated: true) { [weak self] in
			self?.onPreparedImage?(image)
			self?.preparedImage = image
		}
	}
}

// MARK: - PHPickerViewControllerDelegate

extension ImagePicker: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		picker.dismiss(animated: true) { [weak self] in
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
