//
//  ToastModifier.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/13/24.
//

import Foundation
import SwiftUI

extension View {

  func toastView(toast: Binding<Toast?>) -> some View {
    self.modifier(ToastModifier(toast: toast))
  }
}

struct ToastModifier: ViewModifier {

  @Binding var toast: Toast?
  @State private var workItem: DispatchWorkItem?

  func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .overlay(
        ZStack {
          mainToastView()
            .offset(y: 16)
        }.animation(.spring(), value: toast)
      )
      .onChange(of: toast) { value in
        showToast()
      }
  }

  @ViewBuilder func mainToastView() -> some View {
    if let toast = toast {
      VStack {
        ToastView(
          style: toast.style,
          message: toast.message,
          width: toast.width
        ) {
          dismissToast()
        }
        Spacer()
      }
      .transition(.move(edge: .top))
      //.transition(AnyTransition.opacity.animation(.linear))
      //.transition(AnyTransition.scale.animation(.linear))
      //.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.1)))
    }
  }

  private func showToast() {
    guard let toast = toast else { return }

    UIImpactFeedbackGenerator(style: .light)
      .impactOccurred()

    if toast.duration > 0 {
      workItem?.cancel()

      let task = DispatchWorkItem {
        dismissToast()
      }

      workItem = task
      DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
    }
  }

  private func dismissToast() {
    withAnimation {
      toast = nil
    }

    workItem?.cancel()
    workItem = nil
  }
}
