//
//  HomeRouter.swift
//  Recipe
//
//  Created by Gopinath V on 19/08/25.
//

import SwiftUI


enum HomeRouterView {
    @MainActor
    static func createModule(path:Binding<NavigationPath>, apiManager:APIManager) -> some View {
        let interactor = HomeInterActor(apiManager: apiManager)
        let router = HomeRouter()
        let presenter = HomePresenter(interactor: interactor, router: router)
        return HomeView(presenter: presenter, path: path)
    }
}

protocol HomeRouterProtocol {
    func navigateToProfile(path: Binding<NavigationPath>)
    func navigateToFavourite(path: Binding<NavigationPath>)

    func navigateToDetail(path: Binding<NavigationPath>, recipe: Recipes)
}

class HomeRouter: HomeRouterProtocol {
    func navigateToFavourite(path: Binding<NavigationPath>) {
        path.wrappedValue.append("Favourtie")
    }
    
    func navigateToProfile(path: Binding<NavigationPath>) {
        path.wrappedValue.append("Profile")
    }
    
   
    static var selectedRecipe: Recipes?
    
    func navigateToSingup(path: Binding<NavigationPath>) {
        
    }
    
    func navigateToForgetPass(path: Binding<NavigationPath>) {
        
    }
    
    func navigateToDetail(path: Binding<NavigationPath>, recipe: Recipes) {
        HomeRouter.selectedRecipe = recipe
        path.wrappedValue.append("Detail")
    }
    
    
}
