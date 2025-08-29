//
//  LoginRouter.swift
//  Recipe
//
//  Created by Gopinath V on 18/08/25.
//

import SwiftUI


enum LoginRouterView{
    
  
    
    @MainActor
    static func createModule(path:Binding<NavigationPath>, apiManager: APIManager) -> some View {
       return LoginView(presenter: LoginPresenter(interactor: LoginInteractor(apiManager: apiManager), router: LoginRouter()), path: path)
    }

    
}

protocol LoginRouterProtocol {
    func navigateToSingup(path: Binding<NavigationPath>)
    func navigateToForgetPass(path: Binding<NavigationPath>)
    func navigateToDashBoard(path: Binding<NavigationPath>)
}

class LoginRouter: LoginRouterProtocol {
    
    func navigateToSingup(path: Binding<NavigationPath>) {
        path.wrappedValue.append("Singup")
    }
    
    func navigateToForgetPass(path: Binding<NavigationPath>) {
        path.wrappedValue.append("ForgetPass")
    }
    
    func navigateToDashBoard(path: Binding<NavigationPath>) {
        path.wrappedValue.append("Home")
    }
    
}
