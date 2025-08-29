//
//  API.swift
//  Recipe
//
//  Created by Gopinath V on 20/08/25.
//

import Foundation

protocol API:ObservableObject {
    
    func fetchBanners() async throws -> [Banner]?
    
    func fetchRecipes() async throws -> [Recipes]?

    func bannerUrl(for endpoint: Endpoint) -> URL?
    
    func recipeUrl(for endpoint: Endpoint) -> URL?

    
}



enum Endpoint: String {
    
    case banner
    
    case recipe
}




