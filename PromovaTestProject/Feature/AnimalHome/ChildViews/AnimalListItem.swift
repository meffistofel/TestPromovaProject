//
//  AnimalListItem.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import SwiftUI

extension CGFloat {
    static let imageWidth: CGFloat = .relative(to: .width, value: 121)
    static let cellHeight: CGFloat = .relative(to: .height, value: 90)
    static let cellCornerRadius: CGFloat = 6
    static let cellContentPadding: CGFloat = 5
}

struct AnimalListItem: View {

    let model: Model

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            AsyncImageApp(
                url: model.image,
                width: .imageWidth
            )

            VStack(alignment: .leading, spacing: 0) {
                cardDescriptionView
                    .padding(.leading, 17)

                Spacer()

                if !model.isAvailable {
                    lockView
                        .padding(.leading, 12)

                }
            }
            .padding(.top, 5)

            Spacer(minLength: 8)
        }
        .frame(height: .cellHeight)
        .padding(.cellContentPadding)
        .background(.appWhite)
        .overlay(alignment: .trailing) {
            if model.isComingSoon {
                comingSoonView
            }
        }
        .clipShape(.rect(cornerRadius: .cellCornerRadius))
        .compositingGroup()
        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
    }
}

// MARK: Subviews
private extension AnimalListItem {
    var cardDescriptionView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(model.title)
                .font(.basicTitle)
                .foregroundStyle(.appBlack)
            Text(model.description)
                .font(.basicSubTitle)
                .foregroundStyle(.appSubtitle)
        }
    }
    var lockView: some View {
        Label(
            title: {
                Text("Premium")
                    .font(.basicTitle)
            },
            icon: {
                Image(.imageLock)
            }
        )
        .foregroundStyle(.appBlue)
        .labelStyle(.adaptive(spacing: 4))
    }
    var comingSoonView: some View {
        ZStack(alignment: .trailing) {
            Color.appBlack.opacity(0.6)
            Image(.imageComingSoon)
                .rotationEffect(.degrees(-45))
                .padding(.trailing, 14)
        }
    }
}

// MARK: - Local model
extension AnimalListItem {
    struct Model {
        let id: String
        let title: String
        let description: String
        let image: String
        let isAvailable: Bool
        let isComingSoon: Bool

        init(model: Animal) {
            id = model.id
            title = model.title
            description = model.description
            image = model.image
            isAvailable = model.status.isAvailable
            isComingSoon = !model.contentIsAvailable
        }
        
        static var mock: Self { .init(model: Animal.mock(maxIndex: 0)[0]) }
    }
}

#Preview {
    AnimalListItem(model: .mock)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 20)
        .background(.appBackground)
}
