//
//  APIManager.swift
//  Recipe
//
//  Created by Gopinath V on 20/08/25.
//

import SwiftUI
import Combine


let AddBannerUrl = "https://pubservices.banyanpro.com/api/"

let RecipeBaseUrl = "https://pubservices.banyanpro.com/api/"

import Combine

final class APIManager: ObservableObject, API {


    
    private var cancellables = Set<AnyCancellable>()
    
  //  private let keychain = KeychainHelper.shared
    
    let services = "com.recipe.app"

    
    
    func fetchBanners() async throws -> [Banner]? {
        
        guard let url = bannerUrl(for: .banner) else {
                throw MyRecipeError.invalidUrl
            }

            let publisher: AnyPublisher<[Banner]?, Error> = NetworkManager.shared.createRequest(url: url, requestType: .GET)
            for try await value in publisher.values {
                return value ?? []
            }
            return []
        
    }

    
    func fetchRecipes() async throws -> [Recipes]? {
        guard let url = recipeUrl(for: .recipe) else {
            throw MyRecipeError.invalidUrl
        }

        let publisher: AnyPublisher<[Recipes]?, Error> = NetworkManager.shared.createRequest(url: url, requestType: .GET)
        for try await value in publisher.values {
            return value ?? []
        }
        return []
        
    }

    
    func bannerUrl(for endpoint: Endpoint) -> URL? {
        
        return URL(string: AddBannerUrl + endpoint.rawValue)

    }
    
    
    func recipeUrl(for endpoint: Endpoint) -> URL? {
        
        return URL(string: RecipeBaseUrl + endpoint.rawValue)

    }
}


extension APIManager : DataManager {
   
 
    
    func saveUserDetail(credentials: UserCredentials) async throws -> Bool {
        
//        keychain.save(Data(credentials.userId.utf8),
//                              service: services,
//                              account: "userId")
//       keychain.save(Data(credentials.password.utf8),
//                              service: services,
//                              account: "password")
//        
        return true
    }
    
    func fetchUserDetails() throws -> UserCredentials? {
//        
//        guard let userIdData = keychain.read(service: services, account: "userId"),
//              let passwordData = keychain.read(service: services, account: "password"),
//              let userId = String(data: userIdData, encoding: .utf8),
//              let password = String(data: passwordData, encoding: .utf8)
//        else {
//            return nil
//        }
        
       // return UserCredentials(userId: userId, password: password)

        return nil
    }
    
    func deleteUser() {
        
//        keychain.delete(service: services, account: "userId")
//        keychain.delete(service: services, account: "password")

        self.deleteAll()
    }
    
    func deleteAll()  {
        let status = CoreDataManager.shared.deleteAll()
        print("All deleted",status)

    }
    
    func addFavRecipe(recipe: Recipes) async throws -> Bool {
        
        return CoreDataManager.shared.addFavRecipe(recipe: recipe)
    }
    
    func deleteRecipe(recipeId: Int) async throws -> Bool {
        let recipes =  CoreDataManager.shared.removeFavRecipe(id: recipeId)
        print(recipes)
        return true
    }
    
    func fetchAllFavRecipes() async throws -> [Recipes] {

        return CoreDataManager.shared.fetchAllFavRecipes()
        
    }
    
    func findRecipe(id: Int) async throws -> Recipes? {
        let recipes = CoreDataManager.shared.fetchFavRecipe(id: id)
        return recipes.first { $0.id == id }
    }
    
}
