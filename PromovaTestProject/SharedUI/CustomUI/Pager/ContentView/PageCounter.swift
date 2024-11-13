//
//  PageCounter.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/13/24.
//

import SwiftUI

// MARK: - PageCounter
struct PageCounter: View {

    // MARK: - Properties

    let numberOfPages: Int
    let currentIndex: Int

    // MARK: - Drawing Constants

    let style: Style

    // MARK: - Init

    init(numberOfPages: Int, currentIndex: Int, style: Style = .init()) {
        self.numberOfPages = numberOfPages
        self.currentIndex = currentIndex
        self.style = style
    }


    // MARK: - Body

    var body: some View {
        HStack(spacing: style.circleSpacing) {
            ForEach(0..<numberOfPages, id: \.self) { index in // 1
                /// check what index dots need to show or no
                if shouldShowIndex(index) {
                    Circle()
                        .fill(currentIndex == index ? style.primaryColor : style.secondaryColor) // 2
                        .scaleEffect(scaleEffect(with: index))
                        .frame(width: style.circleSize, height: style.circleSize)
                        .transition(AnyTransition.opacity.combined(with: .scale)) // 3
                        .id(index) // 4
                        .animation(.default, value: currentIndex)
                }
            }
        }
    }

    // MARK: - Private Methods

    private func shouldShowIndex(_ index: Int) -> Bool {
        ((currentIndex - style.maxDotCounts.additionalDot)...(currentIndex + style.maxDotCounts.additionalDot)).contains(index)
    }

    private func scaleEffect(with index: Int) -> CGFloat {
        if style.maxDotCounts.isNeedAdditionalScale,
           currentIndex - style.maxDotCounts.additionalDot == index || currentIndex + style.maxDotCounts.additionalDot == index {
            return style.smallScale - 0.2
        }
        return currentIndex == index ? 1 : style.smallScale
    }
}

