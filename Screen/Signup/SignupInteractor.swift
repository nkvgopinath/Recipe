//
//  SignupInteractor.swift
//  Recipe
//
//  Created by Gopinath V on 18/08/25.
//

import Foundation

import SwiftUI



enum SignupError: LocalizedError {
    case emptyFields
    case invalidEmail
    case weakPassword
    case serverError
    
    var errorDescription: String? {
        switch self {
        case .emptyFields: return "All fields are required."
        case .invalidEmail: return "Enter a valid email."
        case .weakPassword: return "Password must be at least 6 characters."
        case .serverError: return "Server error. Please try again."
        }
    }
}


final class SignupInteractor {
    
    let apiManager:APIManager
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
    
    func register(userId: String, password: String) async throws -> Bool {
        
        guard !userId.isEmpty, !password.isEmpty else {
            throw SignupError.emptyFields
        }
        
        guard password.count >= 6 else {
            throw SignupError.weakPassword
        }
       
        let credentials = UserCredentials(userId: userId, password: password)
        
        return try await apiManager.saveUserDetail(credentials: credentials)

        
    }
}
