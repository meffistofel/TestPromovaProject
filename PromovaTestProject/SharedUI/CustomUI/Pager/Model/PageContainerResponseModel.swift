//
//  PageContainerResponseModel.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/13/24.
//

import Foundation

struct PageContainerResponseModel<T: Identifiable> {
    let index: Int
    let item: T
}
