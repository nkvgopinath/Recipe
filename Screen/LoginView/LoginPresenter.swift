//
//  LoginPresenter.swift
//  Recipe
//
//  Created by Gopinath V on 18/08/25.
//

import Foundation


import SwiftUI

@MainActor
final class LoginPresenter: ObservableObject {
    
    @Published var userId: String = ""
    @Published var password: String = ""
    
    @Published var navigateToSignup: Bool = false
    
    @Published var showAlert = false
    
    @Published var alertMessage:String = ""

    
    private let interactor: LoginInteractor
    
    private let router: LoginRouter
    
    
    
    init(interactor: LoginInteractor, router: LoginRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func loginTapped(path:Binding<NavigationPath>) {
        
        guard !userId.isEmpty, !password.isEmpty else {
                   alertMessage = "Please enter email and password"
                   showAlert = true
                   return
               }
        
        
        Task {
            do {
                let credentials = try await interactor.checkAuthentication(userId: userId, password: password)
                if let userCredentials = credentials {
                    router.navigateToDashBoard(path: path)
                }else {
                    showAlert = true
                    alertMessage = "Invalid UserId and Password"
                }
                
                
            }catch  {
                if case MyRecipeError.InvalidUser = error {
                    showAlert = true
                    alertMessage = "Invalid UserId and Password"
                }
            }
        }
    }
    
    func signupTapped(path: Binding<NavigationPath>) {
        navigateToSignup = true
        router.navigateToSingup(path: path)
    }
    
    func resetPass(path:Binding<NavigationPath>) {
        router.navigateToForgetPass(path: path)
    }
}
