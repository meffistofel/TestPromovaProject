//
//  PageContainer.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/13/24.
//

import SwiftUI

// MARK: - PageContainer

struct PageContainer<
    HeaderContent: View,
    ListContent: View,
    ListHeader: View,
    ListFooter: View,
    T: Identifiable
>: View {

    // MARK: - Wrapped Properties

    // structure that configures the UI this view
    @State private var pagerConfig: PagerConfig

    // current index
    @Binding private var currentIndex: Int

    // MARK: - Properties

    private let listItem: [T]
    /// pager counter customization
    private let pageCounterStyle: PageCounter.Style
    /// card customization
    private let cardStyle: CardStyle
    /// all content that does not include list item
    private let headerContent: (PageContainerResponseModel<T>) -> HeaderContent
    /// list header
    private let listHeader: ListHeader
    /// list footer
    private let listFooter: (PageContainerResponseModel<T>) -> ListFooter
    /// listContent
    private let listContent: (PageContainerResponseModel<T>) -> ListContent


    // MARK: - Init

    init(
        currentIndex: Binding<Int>,
        listItem: [T],
        pagerConfig: PagerConfig = .init(),
        pageCounterStyle: PageCounter.Style = PageCounter.Style(),
        cardStyle: CardStyle = CardStyle(),
        headerContent: @escaping (PageContainerResponseModel<T>) -> HeaderContent,
        @ViewBuilder listHeader:  () -> ListHeader = { EmptyView() },
        @ViewBuilder listContent: @escaping (PageContainerResponseModel<T>) -> ListContent,
        @ViewBuilder listFooter:  @escaping (PageContainerResponseModel<T>) -> ListFooter
    ) {
        self._currentIndex = currentIndex
        self.listItem = listItem
        self._pagerConfig = .init(wrappedValue: pagerConfig)
        self.pageCounterStyle = pageCounterStyle
        self.cardStyle = cardStyle
        self.headerContent = headerContent
        self.listContent = listContent
        self.listHeader = listHeader()
        self.listFooter = listFooter
    }

    init(
        currentIndex: Binding<Int>,
        listItem: [T],
        pagerConfig: PagerConfig = .init(),
        pageCounterStyle: PageCounter.Style = PageCounter.Style(),
        cardStyle: CardStyle = CardStyle(),
        headerContent: @escaping (PageContainerResponseModel<T>) -> HeaderContent,
        @ViewBuilder listHeader:  () -> ListHeader = { EmptyView() },
        @ViewBuilder listFooter:  @escaping (PageContainerResponseModel<T>) -> ListFooter
    ) where ListContent == EmptyView {
        self.init(
            currentIndex: currentIndex,
            listItem: listItem,
            pagerConfig: pagerConfig,
            pageCounterStyle: pageCounterStyle,
            cardStyle: cardStyle,
            headerContent: headerContent,
            listHeader: listHeader,
            listContent: { _ in EmptyView() },
            listFooter: listFooter
        )
    }

    // MARK: - body View

    var body: some View {
        VStack {
            PageCarousel(
                index: $currentIndex.animation(),
                items: listItem,
                viewConfig: pagerConfig
            ) { item, index in
                let model = PageContainerResponseModel(index: index, item: item)

                GeometryReader { geo in
                    VStack {
                        /// header content without list
                        VStack(spacing: 0) {
                            headerContent(model)

                            if !(listHeader is EmptyView) {
                                listHeader
                            }
                        }
                        .readSize {
                            pagerConfig.setHeaderHeight(with: $0.height + 50)
                        }

                        if !(listContent(model) is EmptyView) {
                            /// content with list
                            ScrollIfNeeded(isNeedScroll: pagerConfig.scrollEnabled(with: index)) {
                                VStack(alignment: pagerConfig.listConfig.listAlignment, spacing: pagerConfig.listConfig.listSpacingBetweenElement) {
                                    listContent(model)
                                }
                                .readSize {
                                    /// calculated dynamic heigt to each card
                                    pagerConfig.setExampleListHeight(with: $0.height, and: index)
                                }
                            }
                            // horizontal padding scroll view
                            .padding(.bottom, pagerConfig.listConfig.listVerticalPadding.bottom)
                            .padding(.bottom, pagerConfig.listConfig.listVerticalPadding.top)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        }

                        listFooter(model)

                    }
                    /// we count the height of the card in order to understand in the future whether it is necessary to include scrolling or not for the list
                    .readSize {
                        pagerConfig.setCardHeight(with: $0.height)
                    }
                    .frame(width: geo.size.width)
                    // paddings for top and bottom cards required for correct pagination calculation
                    .padding(.leading, pagerConfig.listConfig.listHorizontalPadding.leading)
                    .padding(.trailing, pagerConfig.listConfig.listHorizontalPadding.trailing)
                    .background {
                        RoundedRectangle(cornerRadius: cardStyle.cornerRadius)
                            .fill(cardStyle.fill, strokeBorder: cardStyle.border.color, lineWidth: cardStyle.border.lineWidth)
                            .cardShadow(with: cardStyle.shadow)
                    }
                }
            }
            // paddings for top and bottom cards
            .padding(.top, pagerConfig.cardConfig.cardTopPadding)
            .padding(.bottom, pagerConfig.cardConfig.cardBottomPadding)


            if pageCounterStyle.isVisible {
                PageCounter(
                    numberOfPages: listItem.count,
                    currentIndex: currentIndex,
                    style: pageCounterStyle
                )
            }
        }
    }
}

