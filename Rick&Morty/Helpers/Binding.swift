//
//  Binding.swift
//  Rick&Morty

//import Foundation
//
//final class Binding<T> {
//	
//	typealias Listener = (T) -> Void
//	
//	private var listener: Listener?
//	
//	var value: T {
//		didSet {
//			listener?(value)
//		}
//	}
//	
//	func bind(listener: @escaping Listener) {
//		self.listener = listener
//		listener(value)
//	}
//	
//	init(value: T) {
//		self.value = value
//	}
//}
