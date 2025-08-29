//
//  FavouritePresenter.swift
//  Recipe
//
//  Created by Gopinath V on 21/08/25.
//

import SwiftUI
import Combine


@MainActor
final class FavouritePresenter: ObservableObject {
    
    @Published var favRecipes:[Recipes] = []
        
    
    private let interactor: FavouriteInterActor
    
    private let router: FavouriteRouter
    
    init(interactor: FavouriteInterActor, router: FavouriteRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func fetchAllFav(){
        Task {
            do {
                favRecipes = try await  interactor.fetchAllFav()
            }catch {
                favRecipes = []
            }
        }
    }
    
    func navigateDetail(path:Binding<NavigationPath>, recipe: Recipes){
        HomeRouter.selectedRecipe = recipe
        router.navigateToDetail(path: path, recipe: recipe)
    }
    
    func removeFavRecipe(id: Int) {
        Task {
            do {
                let success = try await interactor.removeFavRecipe(id: id)
                if success {
                    // Refresh the favorites list after removal
                    fetchAllFav()
                }
            } catch {
                print("Error removing favorite recipe: \(error)")
            }
        }
    }
    
    
}
