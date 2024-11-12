//
//  CGFloat+Extension.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import UIKit

extension CGFloat {
    enum ScreenSize {
        case width
        case height
    }
    static func relative(to screenSize: ScreenSize, value: CGFloat) -> CGFloat {
        let size = screenSize == .height ? UIApplication.viewBounds.height : UIApplication.viewBounds.width
        let generalSize: CGFloat = screenSize == .height ? 844 : 390

        let relativePadding = (size / generalSize) * value

        return relativePadding
    }
}
