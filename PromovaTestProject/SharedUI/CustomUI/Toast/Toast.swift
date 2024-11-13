//
//  Toast.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/13/24.
//

import Foundation

struct Toast: Equatable {
  var style: ToastStyle
  var message: String
  var duration: Double = 3
  var width: Double = .infinity
}
