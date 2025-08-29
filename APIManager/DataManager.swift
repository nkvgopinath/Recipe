//
//  File.swift
//  Recipe
//
//  Created by Gopinath V on 20/08/25.
//

import Foundation


protocol DataManager {
    
    func saveUserDetail(credentials: UserCredentials) async throws -> Bool
    
    func fetchUserDetails() throws -> UserCredentials?
    
    func deleteUser()
    
    func deleteAll()

    func addFavRecipe(recipe: Recipes)async throws -> Bool

    func deleteRecipe(recipeId: Int)async throws -> Bool

    func fetchAllFavRecipes() async throws -> [Recipes]
    
    func findRecipe(id:Int)async throws ->Recipes?
    
}



