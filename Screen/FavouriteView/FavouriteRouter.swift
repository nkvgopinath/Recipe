//
//  FavouriteRouter.swift
//  Recipe
//
//  Created by Gopinath V on 21/08/25.
//

import Foundation
import SwiftUI

enum FavouriteRouterView {
    @MainActor static func createModule(path:Binding<NavigationPath>, apiManager:APIManager) -> some View {
        let interactor = FavouriteInterActor(apiManager: apiManager)
        let router = FavouriteRouter()
        let presenter = FavouritePresenter(interactor: interactor, router: router)
        return FavouriteView(presenter: presenter, path: path)
    }
}

protocol FavouriteRouterProtocol {
    func navigateToProfile(path: Binding<NavigationPath>)
}

class FavouriteRouter: FavouriteRouterProtocol {
    func navigateToProfile(path: Binding<NavigationPath>) {
        path.wrappedValue.append("Profile")
    }
    
    
    func navigateToDetail(path: Binding<NavigationPath>, recipe: Recipes) {
        HomeRouter.selectedRecipe = recipe
        path.wrappedValue.append("Detail")
    }

    
}
