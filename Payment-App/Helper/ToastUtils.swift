//
//  ToastUtils.swift
//  Payment-App
//
//  Created by Mahipal on 13/04/23.
//

import Foundation
import Toaster
import UIKit

class ToastUtils {
    
    static let shared = ToastUtils()
    
    private init() {
        configureToast()
    }
    
    private func configureToast() {
        ToastView.appearance().backgroundColor = UIColor.black
        ToastView.appearance().font = UIFont.systemFont(ofSize: 15, weight: .medium)
        ToastView.appearance().textColor = UIColor.white
    }
    
    func show(with message: String) {
        DispatchQueue.main.async {
            Toast.init(text: message).show()
        }
    }
}
