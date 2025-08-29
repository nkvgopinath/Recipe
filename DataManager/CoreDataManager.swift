//
//  CoreDataManager.swift
//  Recipe
//
//  Created by Gopinath V on 21/08/25.
//


import CoreData
import UIKit

protocol CoreDataProtocol{
    
    init()
    
    func addFavRecipe(recipe:Recipes)-> Bool
    
    func fetchFavRecipe(id:Int)->[Recipes]
    
    func fetchAllFavRecipes()->[Recipes]

    
    func removeFavRecipe(id:Int)->[Recipes]
    
    func deleteAll()-> Bool
    
}

final class CoreDataManager:CoreDataProtocol  {
    
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    internal init() {
        persistentContainer = NSPersistentContainer(name: "Recipes")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data store failed: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    func addFavRecipe(recipe: Recipes)-> Bool {
        
            let entity = RecipesEntity(context: self.context)
            entity.chefName = recipe.chefName
            entity.cookingTime = recipe.cookingTime
            entity.cuisineType = recipe.cuisineType
            entity.dietType = recipe.dietType
            entity.id = Int32(recipe.id ?? 0)
            entity.imageURL = recipe.imageURL
            entity.ingredients = recipe.ingredients
            entity.recipeDetail = recipe.recipeDetail
            entity.recipeName = recipe.recipeName
            entity.steps = recipe.steps
            
            do {
            try self.context.save()
                return true
            } catch {
                return false
            }
    }
    
    func fetchFavRecipe(id: Int) -> [Recipes] {
       
        let fetchRequest: NSFetchRequest<RecipesEntity> = RecipesEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", id)
                
                do {
                    let entities = try context.fetch(fetchRequest)
                    return entities.map { entity in
                        Recipes(
                            chefName: entity.chefName,
                            cookingTime: entity.cookingTime,
                            cuisineType: entity.cuisineType,
                            dietType: entity.dietType,
                            id: Int(entity.id),
                            imageURL: entity.imageURL,
                            ingredients: entity.ingredients,
                            recipeDetail: entity.recipeDetail,
                            recipeName: entity.recipeName,
                            steps: entity.steps
                        )
                    }
                } catch {
                    print("Failed to fetch recipes: \(error)")
                    return []
                }
    }
    
    func removeFavRecipe(id: Int) -> [Recipes] {
        let fetchRequest: NSFetchRequest<RecipesEntity> = RecipesEntity.fetchRequest()
             fetchRequest.predicate = NSPredicate(format: "id == %d", id)
             
             do {
                 let entities = try context.fetch(fetchRequest)
                 for entity in entities {
                     context.delete(entity)
                 }
                 try context.save()
             } catch {
                 print("Failed to delete recipe: \(error)")
             }
             
             return fetchAllFavRecipes()
    }
    
    func fetchAllFavRecipes() -> [Recipes] {
        let fetchRequest: NSFetchRequest<RecipesEntity> = RecipesEntity.fetchRequest()
           
           do {
               let entities = try context.fetch(fetchRequest)
               return entities.map { self.mapToRecipe(entity: $0) }
           } catch {
               print("Failed to fetch all recipes: \(error)")
               return []
           }
    }
    
    
    
    func deleteAll() -> Bool {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = RecipesEntity.fetchRequest()
             let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
             
             do {
                 try context.execute(batchDeleteRequest)
                 try context.save()
                 return true
             } catch {
                 return false
             }
    
    }
    
    
    private func mapToRecipe(entity: RecipesEntity) -> Recipes {
        return Recipes(
            chefName: entity.chefName,
            cookingTime: entity.cookingTime,
            cuisineType: entity.cuisineType,
            dietType: entity.dietType,
            id: Int(entity.id),
            imageURL: entity.imageURL,
            ingredients: entity.ingredients,
            recipeDetail: entity.recipeDetail,
            recipeName: entity.recipeName,
            steps: entity.steps
        )
    }
}
    
