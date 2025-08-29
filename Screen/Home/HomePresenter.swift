//
//  HomePresenter.swift
//  Recipe
//
//  Created by Gopinath V on 19/08/25.
//

import SwiftUI


@MainActor
final class HomePresenter: ObservableObject {
    
    @Published var email: String = ""
    
    @Published var password: String = ""
    
    @Published var navigateToSignup: Bool = false
    
    @Published var adBanner:[Banner] = []
    
    @Published var recipes:[Recipes] = []
    
    @Published var selectedRecipe: Recipes? = nil
    
    private let interactor: HomeInterActor
    
    private let router: HomeRouter
    
    init(interactor: HomeInterActor, router: HomeRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func fetchBanner() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let adBanner = try await  interactor.fetchBanner()
               // self.adBanner = adBanner
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func fetchRecipe() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let recipes = try await  interactor.fetchRecipe()
              //  self.recipes = recipes
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func navigateProfile(path: Binding<NavigationPath>) {
        router.navigateToProfile(path: path)
    }
    
   
    func navigateFavourite(path:Binding<NavigationPath>) {
        router.navigateToFavourite(path: path)
    }
    
    func navigateDetail(path:Binding<NavigationPath>, recipe: Recipes){
        self.selectedRecipe = recipe
        router.navigateToDetail(path: path, recipe: recipe)
    }
}
