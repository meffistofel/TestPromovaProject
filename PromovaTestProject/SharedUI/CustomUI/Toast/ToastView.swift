//
//  ToastView.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/13/24.
//

import SwiftUI

struct ToastView: View {

    var style: ToastStyle
    var message: String
    var width = CGFloat.infinity
    var onCancelTapped: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: style.iconFileName)
                .foregroundColor(style.themeColor)
            Text(message)
                .foregroundStyle(.appBlack)
                .font(Font.caption)

            Spacer(minLength: 10)

            Button {
                onCancelTapped()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(style.themeColor)
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .cornerRadius(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.appWhite, strokeBorder: style.themeColor, lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 32) {
            ToastView(
                style: .success,
                message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ") {}
            ToastView(
                style: .info,
                message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ") {}
            ToastView(
                style: .warning,
                message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ") {}
            ToastView(
                style: .error,
                message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ") {}
        }
        .background(.appBackground)
    }
}

