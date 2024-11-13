//
//  AnimalDetailCardView.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/13/24.
//

import SwiftUI

private extension CGFloat {
    static let cellCornerRadius: CGFloat = 6
}

struct AnimalDetailActionButtonView: View {
    let backwardIsAvailable: Bool
    let forwardIsAvailable: Bool

    let onEvent: (Event) -> Void

    var body: some View {
        HStack(spacing: 0) {
            button(direction: .back) {
                onEvent(.didTapBackward)
            }
            .opacity(backwardIsAvailable ? 1 : 0)
            
            Spacer()
            
            button(direction: .forward) {
                onEvent(.didTapForward)
            }
            .opacity(forwardIsAvailable ? 1 : 0)
        }
    }

    private func button(direction: Direction, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: "chevron.backward")
                .rotationEffect(.degrees(direction == .back ? 0 : 180))
                .foregroundStyle(.appBlack)
                .font(.headline)
                .frame(width: 52, height: 52)
                .background {
                    Circle()
                        .stroke(Color.appBlack, lineWidth: 2)
                }
        }
    }
}

extension AnimalDetailActionButtonView {
    enum Event {
        case didTapBackward
        case didTapForward
    }
    private enum Direction {
        case back
        case forward
    }
}

#Preview {
    Preview()
}

private struct Preview: View {

    private let models: [AnimalContent] = AnimalContent.mock()
    @State private var currentIndex: Int = 0

    var body: some View {
        AnimalDetailActionButtonView(
            backwardIsAvailable: currentIndex > 0,
            forwardIsAvailable: currentIndex < models.count - 1
        ) { event in
            switch event {
            case .didTapBackward:
                currentIndex -= 1
            case .didTapForward:
                currentIndex += 1
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
    }
}
