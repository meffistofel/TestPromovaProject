//
//  ForEach+Index.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/13/24.
//

import SwiftUI

struct ForEachWithIndex<
    Data: RandomAccessCollection,
    Content: View
>: View where Data.Element: Identifiable {
    let data: Data
    @ViewBuilder let content: (Int, Data.Element) -> Content

    var body: some View {
        ForEach(Array(data.enumerated()), id: \.offset) { index, element in
            content(index, element)
        }
    }
}
