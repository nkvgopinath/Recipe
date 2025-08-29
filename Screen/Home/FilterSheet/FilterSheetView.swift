//
//  FilterSheetView.swift
//  Recipe
//
//  Created by Gopinath V on 20/08/25.
//
import SwiftUI


struct FilterData {
    var cuisine: Bool
    var dietaryNeeds: Bool
    var cookingTime: Bool
    var ingredients: Bool
}

struct FilterSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var filters = FilterData(
        cuisine: false,
        dietaryNeeds: false,
        cookingTime: false,
        ingredients: false
    )
    
    var onApply: (FilterData) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Search Recipe")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 20)
            
        
            Button(action: {
                filters.cuisine.toggle()
            }) {
                Text("Cuisine")
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(filters.cuisine ? Color.red : Color.gray.opacity(0.2))
                    .foregroundColor(filters.cuisine ? .white : Color.gray.opacity(0.6))
                    .cornerRadius(8)
            }
            
          
            Button(action: {
                filters.dietaryNeeds.toggle()
            }) {
                Text("Dietary needs")
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(filters.dietaryNeeds ? Color.red : Color.gray.opacity(0.2))
                    .foregroundColor(filters.dietaryNeeds ? .white : Color.gray.opacity(0.6))
                    .cornerRadius(8)
            }
            
            
            Button(action: {
                filters.cookingTime.toggle()
            }) {
                Text("Cooking time")
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(filters.cookingTime ? Color.red : Color.gray.opacity(0.2))
                    .foregroundColor(filters.cookingTime ? .white : Color.gray.opacity(0.6))
                    .cornerRadius(8)
            }
            
  
            Button(action: {
                filters.ingredients.toggle()
            }) {
                Text("Ingredients")
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(filters.ingredients ? Color.red : Color.gray.opacity(0.2))
                    .foregroundColor(filters.ingredients ? .white : Color.gray.opacity(0.6))
                    .cornerRadius(8)
            }
            
           
            Button(action: {
                onApply(filters)
                dismiss()
            }) {
                Text("Search")
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(red: 0.7, green: 0.1, blue: 0.1))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
    }
}
