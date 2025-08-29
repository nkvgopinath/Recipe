//
//  HomeInterActor.swift
//  Recipe
//
//  Created by Gopinath V on 19/08/25.
//

import SwiftUI


final class HomeInterActor {
    
    private let apiManager: APIManager
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
   
    func fetchBanner() async throws -> [Banner]{
      
            do {
                let banners = try await apiManager.fetchBanners()
                return banners ?? []
                
            }catch {
                throw error
        }
    }
    
    
    func fetchRecipe() async throws -> [Recipes]{
      
            do {
                let recipes = try await apiManager.fetchRecipes()
                return recipes ?? []
                
            }catch {
                throw error
        }
    }
    
}
