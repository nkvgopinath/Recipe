//
//  RecipeDetailPresenter.swift
//  Recipe
//
//  Created by Gopinath V on 21/08/25.
//

import Foundation
import SwiftUI



@MainActor
final class RecipeDetailPresenter: ObservableObject {
    
    
    @Published var recipes:[Recipes] = []
    
    @Published var isFav: Bool = false
    
    private let interactor: RecipeDetailInterActor
    
    private let router: RecipeDetailRouter
    
    init(interactor: RecipeDetailInterActor, router: RecipeDetailRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func navigateProfile(path: Binding<NavigationPath>){
        router.navigateToProfile(path: path)
    }
    
    func checkFav(recipeId: Int ){
        Task {
            do {
               isFav = try await interactor.isFavRecipe(id: recipeId)
            }catch {
                isFav = false
            }
        }
    }
    
    
    func favTapAction(recipe:Recipes) {
        if isFav {
            Task {
                _ = try await interactor.removeFav(id: recipe.id ?? 0)
                isFav = false
            }
        }else {
            Task {
                _ = try await interactor.addFav(recipe: recipe)
                isFav = true
            }
        }
    }
    
}
    
