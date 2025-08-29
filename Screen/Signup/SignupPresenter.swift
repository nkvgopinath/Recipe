//
//  SignupPresenter.swift
//  Recipe
//
//  Created by Gopinath V on 18/08/25.
//

import SwiftUI

@MainActor
final class SignupPresenter: ObservableObject {
    
    @Published var userId = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: String?
    
    @Published var yesNavigationBack: Bool = false
    
    @Published var isShowAlert:Bool = false
    
    var alertMessage:String = ""
    
    private let interactor: SignupInteractor
    private let router: SignupRoutingProtocol
    
    init(interactor: SignupInteractor, router: SignupRoutingProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func registerTapped() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        Task {
            do {
              
                let success = try await interactor.register(
                    userId: userId,
                    password: password
                )
                if success {
                    alertMessage = "Kindly got to login now"
                    isShowAlert = true
                   
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func moveToDashBoard(path:Binding<NavigationPath>){
      //  router.moveToHome(path: path)
    }
}
