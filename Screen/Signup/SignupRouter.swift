//
//  SignupRouter.swift
//  Recipe
//
//  Created by Gopinath V on 18/08/25.
//

import Foundation
import SwiftUI

enum SignupRouter {
    @MainActor static func createModule(path:Binding<NavigationPath>, apiManager:APIManager) -> some View {
        let interactor = SignupInteractor(apiManager: apiManager)
        let router = SignupRouterImpl()
        let presenter = SignupPresenter(interactor: interactor, router: router)
        return SignupView(presenter: presenter, path: path)
    }
}

protocol SignupRoutingProtocol {
    func dismissSignup()
    func moveToHome(path:Binding<NavigationPath>)
}

final class SignupRouterImpl: SignupRoutingProtocol {
    func moveToHome(path: Binding<NavigationPath>) {
        path.wrappedValue.append("Home")
    }
    
    func dismissSignup() {
        // Pop or dismiss back to Login
        // In SwiftUI: handled by NavigationStack automatically
    }
}
