//
//  LoginInteractor.swift
//  Recipe
//
//  Created by Gopinath V on 18/08/25.
//

import Foundation


protocol LoginInterActorProtocol:ObservableObject {
    
    func checkAuthentication(userId: String, password: String)async throws -> UserCredentials?
    func saveUserCredentials(credentials: UserCredentials) async throws
    
}

final class LoginInteractor:LoginInterActorProtocol {
   
    
    
   let apiManager: APIManager
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
    
    
    
    func checkAuthentication(userId: String, password: String) async throws -> UserCredentials? {
        do {
            let userDetails = try apiManager.fetchUserDetails()
            
            if userDetails?.userId == userId && userDetails?.password == password {
                return userDetails
            }else {
                return nil
            }
        }catch {
            return nil
        }
    }
    
    func saveUserCredentials(credentials: UserCredentials) async throws {
        _ = try await apiManager.saveUserDetail(credentials: credentials)
    }
    
}
