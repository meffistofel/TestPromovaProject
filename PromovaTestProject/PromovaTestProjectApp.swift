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
