//
//  RecipeDetailView.swift
//  Recipe
//
//  Created by Gopinath V on 19/08/25.
//


import SwiftUI

struct RecipeDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedSegment = 0
    
    @Binding var path:NavigationPath
    
    @StateObject var presenter: RecipeDetailPresenter

    
    var recipe: Recipes?
    
    let segmentTitles = ["About", "Ingredients", "Steps"]
    
    var body: some View {
        VStack(spacing: 0) {
            

            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                Spacer()
                Text("Detail")
                    .font(.headline)
                Spacer()
                Button(action: {
                    presenter.navigateProfile(path: $path)

                }) {
                    Image(systemName: "person.crop.circle")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            ScrollView {
                VStack(spacing: 16) {
                    ZStack(alignment: .topTrailing) {
                        if let imageURL = recipe?.imageURL, let url = URL(string: imageURL) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(height: 200)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 200)
                                        .clipped()
                                        .cornerRadius(12)
                                case .failure(_):
                                    Image("placeholder") // fallback image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 200)
                                        .clipped()
                                        .cornerRadius(12)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Image("placeholder")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            if let mRecipe = recipe {
                                presenter.favTapAction(recipe: mRecipe)
                            }
                        }) {
                            Image(systemName: presenter.isFav ? "heart.fill" : "heart")
                                .font(.system(size: 28))
                                .foregroundColor(presenter.isFav ? AppColors.darkRed : AppColors.darkRed)
                                .padding()
                        }
                    }
                    

                    HStack {
                        Text(recipe?.recipeName ?? "")
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                        Text("Chef: \(recipe?.chefName ?? "")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    // Grey line above segment view
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    HStack(spacing: 8) {
                        ForEach(segmentTitles.indices, id: \.self) { index in
                            Button(action: {
                                selectedSegment = index
                            }) {
                                Text(segmentTitles[index])
                                    .font(.headline)
                                    .foregroundColor(selectedSegment == index ? .white : .black)
                                    .frame(maxWidth: .infinity, minHeight: 36)
                                    .background(
                                        selectedSegment == index
                                        ? AppColors.darkRed
                                        : Color.clear
                                    )
                                    .cornerRadius(8)
                                    
                            }
                        }
                    }.background(Color.gray.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal)
                    

                    VStack(alignment: .leading, spacing: 8) {
                        Text(contentForSegment(selectedSegment))
                            .font(.body)
                            .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                }
                .padding(.horizontal, 16)
            }
        }.onAppear{
            presenter.checkFav(recipeId: recipe?.id ?? 0)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    
    private func contentForSegment(_ segment: Int) -> String {
        switch segment {
        case 0: return recipe?.recipeDetail ?? "No details available"
        case 1: return recipe?.ingredients ?? "No ingredients available"
        case 2: return recipe?.steps ?? "No steps available"
        default: return ""
        }
    }
}
