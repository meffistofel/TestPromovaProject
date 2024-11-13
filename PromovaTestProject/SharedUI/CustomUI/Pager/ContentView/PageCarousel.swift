//
//  PageCarousel.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/13/24.
//

import SwiftUI

// MARK: - PageCarousel

struct PageCarousel<Content: View, T: Identifiable>: View {

    // MARK: - Wrapped Properties

    @GestureState private var offset: CGFloat = 0
    @State private var currentIndex: Int = 0

    @Binding private var index: Int

    // MARK: - Properties

    private var content: ((T, Int)) -> Content
    private let list: [T]

    private let viewConfig: PagerConfig

    private var isZeroIndex: Bool {
        currentIndex == 0
    }

    // MARK: - Init

    init(
        index: Binding<Int>,
         items: [T],
         viewConfig: PagerConfig,
         @ViewBuilder content: @escaping ((T, Int)) -> Content
    ) {
        self.list = items
        self._index = index
        self.viewConfig = viewConfig
        self.content = content
    }

    // MARK: - body View

    var body: some View {

        GeometryReader { proxy in

            let width = viewConfig.calculateWidth(proxy: proxy)
            let adjustMentWidth = viewConfig.calculateAdjustMentWidth()

            HStack(spacing: viewConfig.calculateSpacingBetweenCards()) {
                ForEachWithIndex(data: list) { index, item in
                    GeometryReader { proxyO in
                        content((item, index))
                            .scaleEffect(y: getScale(proxy: proxyO))
                            .background {
                                Color.white.opacity(0.00001)
                                    .frame(width: UIApplication.viewBounds.width, height: UIApplication.viewBounds.height)
                            }
                    }
                    .frame(width: viewConfig.calculateTotalCarouselWidth(proxy: proxy))
                }
            }
            // Spacing will be horizontal padding...
            .padding(.leading, viewConfig.cardSpacing)
            .padding(.trailing, viewConfig.cardSpacing)
            // setting only after 0th index..
            .offset(x: (CGFloat(currentIndex) * -width) + (!isZeroIndex ? adjustMentWidth : 0) + offset)
            .simultaneousGesture(viewConfig.isNeedGesture ? dragGesture(with: width) : nil)
        }
        // handle when change index from manual tap to page controller
        .onChange(of: index) { newIndex in
            if offset == .zero {
                withAnimation {
                    currentIndex = newIndex
                }
            }
        }
        // Animatiing when offset = 0
        .animation(.easeInOut, value: offset == 0)
    }
}

// MARK: Child View

extension PageCarousel {
    private func dragGesture(with width: CGFloat) -> some Gesture {
        DragGesture()
            .updating($offset, body: { value, out, _ in
                out = value.translation.width
            })
            .onEnded({ value in
                let roundIndex = updatingIndex(cardWidth: width, offsetX: value.translation.width)

                print(value.translation.width, roundIndex, max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
)

                // setting min...
                currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                index = currentIndex

            })
    }
}

// MARK: - Private Extension
private extension PageCarousel {
    func updatingIndex(cardWidth: CGFloat, offsetX: CGFloat) -> Int {
        // Updating Current Index....
        // were going to convert the tranlsation into progress (0 - 1)
        // and round the value...
        // based on the progress increasing or decreasing the currentIndex...

        let progress = -offsetX / cardWidth + (offsetX < 0 ? 0.3 : -0.3)

        let roundIndex = progress.rounded()

        return Int(roundIndex)
    }

    func getScale(proxy: GeometryProxy) -> CGFloat {
        let x = proxy.frame(in: .global).minX

        let diff = abs(x)

        if diff < 100 {
            return 1
        }

        return 1 + (100 - diff) / 2000
    }
}

