//
//  PagerConfig.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/13/24.
//

import SwiftUI

/// This is can be config with your model
struct PagerConfig {
    var isNeedGesture: Bool = true
    var cardConfig: Card = .init()
    var listConfig: List = .init()

    // doesnt change this property manual(it's auto calculate)
    private var headerHeight: CGFloat = 0
    private var cardHeight: CGFloat = 0

    // MARK: if the content does not fit in the available space, it is enabled scroll view
    func scrollEnabled(with index: Int) -> Bool {
        return (listConfig.listElementsHeight[index] ?? .zero) + headerHeight > cardHeight
    }

    // MARK: - Property necessary for calculating the total height and after sysytem decides whether scrolling is required
    mutating
    func setHeaderHeight(with height: CGFloat) {
        headerHeight = height
    }

    mutating
    func setCardHeight(with height: CGFloat) {
        cardHeight = max(cardHeight, height)
    }

    mutating
    func setExampleListHeight(with newHeight: CGFloat, and index: Int) {
        listConfig.listElementsHeight[index] = newHeight
    }

    // MARK: - Property necessary for calculating the width of the pager
    var cardHorizontalPadding: CGFloat {
        listConfig.listHorizontalPadding.leading + listConfig.listHorizontalPadding.trailing
    }

    var cardSpacing: CGFloat {
        listConfig.listHorizontalPadding.trailing
    }

    func calculateWidth(proxy: GeometryProxy) -> CGFloat {
        proxy.size.width - (cardHorizontalPadding - cardSpacing)
    }

    func calculateAdjustMentWidth() -> CGFloat {
        (cardHorizontalPadding / 2) - cardSpacing
    }

    func calculateSpacingBetweenCards() -> CGFloat {
        cardSpacing + cardHorizontalPadding
    }

    func calculateTotalCarouselWidth(proxy: GeometryProxy) -> CGFloat? {
         proxy.size.width - cardHorizontalPadding <= 0 ? nil : max(0, proxy.size.width - cardHorizontalPadding * 2)
    }
}

extension PagerConfig {
    struct Card {
        var cardTopPadding: CGFloat = .relative(to: .height, value: 50)
        var cardBottomPadding: CGFloat = 24
    }

    struct List {
        var listHorizontalPadding: (leading: CGFloat, trailing: CGFloat) = (20, 20)
        var listVerticalPadding: (top: CGFloat, bottom: CGFloat) = (0, 8)
        var listAlignment: HorizontalAlignment = .leading
        var listSpacingBetweenElement: CGFloat = 8
        var listElementsHeight: [Int: CGFloat] = [:]
    }
}

