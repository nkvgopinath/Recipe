//
//  LaunchPresenter.swift
//  Recipe
//
//  Created by Gopinath V on 18/08/25.
//

import Foundation
import SwiftUI

protocol LaunchPresenterProtocol: ObservableObject {

    func navigateHome(path: Binding<NavigationPath>)
    func fetchUser()
    func navigate(path: Binding<NavigationPath>)
    func navigateLogin(path: Binding<NavigationPath>)
    
}


class LaunchPresenter: LaunchPresenterProtocol {
    
      private let interactor: LaunchInteractorProtocol
    
      private let router: LaunchRouterProtocol?
    
       private var isLoginedUser:Bool = false
    
      static  var userCredentials:UserCredentials? = nil
     
       
       init(interactor: LaunchInteractorProtocol, router: LaunchRouterProtocol?) {
           self.interactor = interactor
           self.router = router
       }
    
    
    func navigateHome(path: Binding<NavigationPath>) {
        self.router?.navigateHome(path: path)
    }
    
    func fetchUser() {
       
//        if let user = interactor.fetchCredentials() {
//            LaunchPresenter.userCredentials = user
//            isLoginedUser = true  // User is logged in if credentials exist
//        }else {
//            isLoginedUser = false
//        }
       
    }
    
    
    func navigate(path: Binding<NavigationPath>) {
        if isLoginedUser {
            self.router?.navigateHome(path: path)
        }else {
            self.router?.navigateLogin(path: path)

        }
    }
    
    func navigateLogin(path: Binding<NavigationPath>) {
        self.router?.navigateLogin(path: path)
    }

    
}
