//
//  FavouriteView.swift
//  Recipe
//
//  Created by Gopinath V on 20/08/25.
//

import SwiftUI
import Combine


struct FavouriteView: View {
    
    @StateObject var presenter: FavouritePresenter
    
    @Binding var path: NavigationPath

    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    var body: some View {
        Group {
            // Check if favorites list is empty
            if presenter.favRecipes.isEmpty {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("No data found")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(presenter.favRecipes) { recipe in
                            ZStack {
                                // Background card with rounded corners
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                                
                                VStack(spacing: 0) {
                                    // Image container with heart overlay
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.1))
                                        .frame(height: 120)
                                        .overlay(
                                            ZStack(alignment: .topTrailing) {
                                                // AsyncImage with controlled sizing
                                                AsyncImage(url: URL(string: recipe.imageURL ?? "")) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView()
                                                            .progressViewStyle(CircularProgressViewStyle())
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                    case .failure:
                                                        Image(systemName: "photo")
                                                            .font(.title2)
                                                            .foregroundColor(.gray)
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                                .clipped()
                                                
                                                // Heart button overlay
                                                Button(action: {
                                                    if let recipeId = recipe.id {
                                                        presenter.removeFavRecipe(id: recipeId)
                                                    }
                                                }) {
                                                    HStack(spacing: 0) {
                                                        Spacer()
                                                        VStack(spacing: 0) {
                                                            Spacer()
                                                            ZStack {
                                                                Circle()
                                                                    .fill(Color.white)
                                                                    .frame(width: 32, height: 32)
                                                                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                                                                
                                                                Image(systemName: "heart.fill")
                                                                    .font(.system(size: 16))
                                                                    .foregroundColor(AppColors.darkRed)
                                                            }
                                                            Spacer()
                                                        }
                                                        Spacer()
                                                    }
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                                .padding(.top, 8)
                                                .padding(.trailing, 8)
                                            }
                                        )
                                        .clipped()
                                    
                                    // Text container
                                    Rectangle()
                                        .fill(AppColors.darkRed)
                                        .frame(height: 32)
                                        .overlay(
                                            Text(recipe.recipeName ?? "Unknown Recipe")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                                .lineLimit(2)
                                                .multilineTextAlignment(.center)
                                                .padding(.horizontal, 4)
                                        )
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .frame(height: 152) // Fixed total height: 120 (image) + 32 (label)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                            .clipped()
                            .onTapGesture {
                                presenter.navigateDetail(path: $path, recipe: recipe)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
            }
        }
        .onAppear {
            presenter.fetchAllFav()
        }
        .navigationTitle("Favourites")
        .navigationBarTitleDisplayMode(.inline)
    }
    
 
}
