//
//  RecipeApp.swift
//  Recipe
//
//  Created by Gopinath V on 18/08/25.
//

import SwiftUI

@main
struct RecipeApp: App {

    @State private var path = NavigationPath(["Launch"])
    
    @StateObject private var apiManager = APIManager()

    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                Color.clear
                    .navigationDestination(for: String.self) { route in
                        if route == "Launch"{
                            LaunchModule.build(path: $path, apiManager: apiManager)
                        }else  if route == "Login" {
                            LoginRouterView.createModule(path: $path, apiManager: apiManager)
                        }else if route == "Singup" {
                            SignupRouter.createModule(path: $path, apiManager: apiManager)
                        }else if route == "Home" {
                            HomeRouterView.createModule(path: $path, apiManager: apiManager)
                        }else if route == "Detail" {
                            if HomeRouter.selectedRecipe != nil {
                                RecipeDetailRouterView.createModule(path: $path, apiManager: apiManager)
                            }
                        }else if route == "Profile" {
                            ProfileView(path: $path, apiManager: apiManager)
                        }else if route == "Favourtie" {
                            FavouriteRouterView.createModule(path: $path,apiManager: apiManager )
                        }
                    }
            }.environmentObject(apiManager)
        }
    }
}
