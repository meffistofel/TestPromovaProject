//
//  PromovaTestProjectApp.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct PromovaTestProjectApp: App {
    static let store: StoreOf<RootFeature> = RootFeature.initialStore

    var body: some Scene {
        WindowGroup {
            RootHomeView(store: Self.store)
        }
    }
}

private extension PromovaTestProjectApp {

  func setup() {
    let backImage = UIImage.iconArrow.withRenderingMode(.alwaysTemplate)

    let appearance = UINavigationBarAppearance()
    appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
    appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]

    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
    UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
  }
}
