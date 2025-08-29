//
//  RecipeDetailRouter.swift
//  Recipe
//
//  Created by Gopinath V on 21/08/25.
//

import Foundation
import SwiftUI

enum RecipeDetailRouterView {
    @MainActor static func createModule(path:Binding<NavigationPath>, apiManager:APIManager) -> some View {
        let interactor = RecipeDetailInterActor(apiManager: apiManager)
        let router = RecipeDetailRouter()
        let presenter = RecipeDetailPresenter(interactor: interactor, router: router)
        return RecipeDetailView(path: path, presenter: presenter, recipe: HomeRouter.selectedRecipe )
    }
}

protocol RecipeDetailRouterProtocol {
    
    func navigateToProfile(path: Binding<NavigationPath>)

}

class RecipeDetailRouter: RecipeDetailRouterProtocol {
    
    
    
    func navigateToProfile(path: Binding<NavigationPath>) {
        path.wrappedValue.append("Profile")
    }
    
    
}
