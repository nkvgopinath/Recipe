//
//  LaunchInteractor.swift
//  Recipe
//
//  Created by Gopinath V on 18/08/25.
//

import Foundation



protocol LaunchInteractorProtocol {
    func fetchCredentials() -> UserCredentials?
}

class LaunchInteractor: LaunchInteractorProtocol {
    
    let apiManager:APIManager
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
    
    
    func fetchCredentials() -> UserCredentials? {

        do {
            let user =  try apiManager.fetchUserDetails()
            return user
        }catch {
            print(error)
            
        }
        return nil
    }
}
