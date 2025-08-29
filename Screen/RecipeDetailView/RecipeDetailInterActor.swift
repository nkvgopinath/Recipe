//
//  RecipeDetailInterActor.swift
//  Recipe
//
//  Created by Gopinath V on 21/08/25.
//

import Foundation


class RecipeDetailInterActor {
    
    private let apiManager:APIManager
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
    
    func fetchAllFav() async throws  -> [Recipes] {
        return try await  apiManager.fetchRecipes() ?? []
    }
    
    func isFavRecipe(id: Int) async throws->Bool {
        if  let recipe:Recipes = try await apiManager.findRecipe(id:id) {
            if let mId = recipe.id,  mId == id {
                return true
            }
        }
        return false
    }
    
    func addFav(recipe:Recipes) async throws -> Bool {
        return try await apiManager.addFavRecipe(recipe: recipe)
    }
    
    func removeFav(id:Int) async throws -> Bool {
        return try await apiManager.deleteRecipe(recipeId: id)

    }
}
