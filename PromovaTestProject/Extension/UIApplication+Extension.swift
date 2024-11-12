//
//  UIApplication+Extension.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import UIKit

extension UIApplication {
    static var viewBounds: CGSize {
        UIApplication.shared.currentKeyWindow?.screen.bounds.size ?? .zero
    }

    var currentKeyWindow: UIWindow? {
      UIApplication.shared.connectedScenes
        .map { $0 as? UIWindowScene }
        .compactMap { $0 }
        .first?.windows
        .filter { $0.isKeyWindow }
        .first
    }
}
