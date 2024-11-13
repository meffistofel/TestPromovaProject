//
//  CustomAlert.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/11/24.
//

import SwiftUI

struct AlertConfiguration: Equatable {
  let title: LocalizedStringKey
  var subtitle: LocalizedStringKey? = nil
  var buttons: [ButtonConfiguration]
}

struct ButtonConfiguration: Identifiable, Equatable {
  let id: UUID = .init()
  let title: LocalizedStringKey
  let role: ButtonRole
  var action: (() -> Void)?

  static func == (lhs: ButtonConfiguration, rhs: ButtonConfiguration) -> Bool {
    lhs.id == rhs.id
  }
}

extension View {
  func showCustomAlert(alert: Binding<AlertConfiguration?>) -> some View {
    self
      .alert(
        alert.wrappedValue?.title ?? "Error",
        isPresented: Binding(value: alert),
        actions: {
          ForEach(alert.wrappedValue?.buttons ?? []) { button in
            Button(button.title, role: button.role, action: button.action ?? { })
          }
        },
        message: {
          if let subtitle = alert.wrappedValue?.subtitle {
            Text(subtitle)
          }
        }
      )
  }
}
