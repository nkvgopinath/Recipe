//
//  LoginEntity.swift
//  Recipe
//
//  Created by Gopinath V on 18/08/25.
//

import Foundation


struct User:Codable {
    let userid:UUID
    let name:String
    let phone:String
    let city:String
    let favCousine:String
}

struct UserCredentials {
    let userId: String
    let password: String
}

struct Recipes: Identifiable, Codable {
    let chefName:String?
    let cookingTime:String?
    let cuisineType:String?
    let dietType:String?
    let id:Int?
    let imageURL:String?
    let ingredients:String?
    let recipeDetail:String?
    let recipeName:String?
    let steps:String?
}


struct ArrayOfBanner: Codable {
    let Banner:[Banner]?
}

struct Banner: Codable {
    let bannerTitle:String?
    let id:Int?
    let imageURL:String?
    let offerDetails:String?
}
