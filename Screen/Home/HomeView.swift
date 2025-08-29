//
//  HomeView.swift
//  Recipe
//
//  Created by Gopinath V on 19/08/25.
//

import SwiftUI


struct HomeView: View {

    @State private var searchText: String = ""
    
    @State private var selectedPage = 0
    
    @StateObject var presenter: HomePresenter
    
    
    @State private var bannerTask: Task<Void, Never>? = nil

    
    @Binding var path: NavigationPath
    
    @State private var showFilter = false
    
    @State private var showVoiceSearch = false
    
    @UserDefault(key: "profileImageData")
    private var profileImageData: Data?

    var filteredRecipes: [Recipes] {
        if searchText.isEmpty {
            return presenter.recipes
        } else {
            return presenter.recipes.filter { recipe in
                let text = searchText.lowercased()
                return recipe.chefName?.lowercased().contains(text) == true ||
                    recipe.cookingTime?.lowercased().contains(text) == true ||
                    recipe.cuisineType?.lowercased().contains(text) == true ||
                    recipe.dietType?.lowercased().contains(text) == true ||
                    recipe.ingredients?.lowercased().contains(text) == true ||
                    recipe.recipeDetail?.lowercased().contains(text) == true ||
                    recipe.recipeName?.lowercased().contains(text) == true ||
                    recipe.steps?.lowercased().contains(text) == true
            }
        }
    }

    var body: some View {
        ZStack {

            VStack(spacing: 4) {

                HStack {
                    HStack(spacing: 8) {
                        Color.clear
                            .frame(width: 40)
                    }
                    
                    Spacer()
                    Text("Recipes")
                        .font(.system(size: 16, weight: .medium))
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Button(action: { presenter.navigateFavourite(path: $path) }) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 22))
                                .foregroundColor(AppColors.darkRed)
                        }
                        Button(action: { presenter.navigateProfile(path: $path) }) {
                            Group {
                                if let imageData = profileImageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 32, height: 32)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                        )
                                } else {
                                    Image(systemName: "person.crop.circle")
                                        .font(.system(size: 22))
                                }
                            }
                        }
                    }
                }
                .frame(height: 40)
                .padding(.horizontal, 16)
                
                HStack(spacing: 12) {
                    Button(action: { showFilter = true }) {
                        VStack(spacing: 3) {
                            HStack(spacing: 2) {
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: 10, height: 2)
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 2, height: 2)
                            }
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 10, height: 2)

                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 10, height: 2)
                        }
                    }
                    .frame(width: 16)
                    .padding(.leading, 2)
                    
                    ZStack {
                        if searchText.isEmpty {
                            Text("Search")
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                        }
                        TextField("", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .multilineTextAlignment(.center)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }
                    
                    Button(action: { showVoiceSearch = true }) {
                        ZStack {

                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 28, height: 28)
                            
                            Image(systemName: "mic.fill")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 2) {
                                ForEach(0..<3, id: \.self) { index in
                                    Circle()
                                        .fill(Color.blue.opacity(0.3 - Double(index) * 0.1))
                                        .frame(width: 4 - Double(index), height: 4 - Double(index))
                                }
                            }
                            .offset(x: 16)
                        }
                    }
                    .padding(.trailing, 8)
                }
                .frame(height: 44)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black.opacity(0.3), lineWidth: 1) // Added border
                )
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                .padding(.horizontal, 16)
                
                TabView(selection: $selectedPage) {
                    ForEach(Array(presenter.adBanner.enumerated()), id: \.element.id) { index, banner in
                        AsyncImage(url: URL(string: banner.imageURL ?? "")) { phase in
                            switch phase {
                            case .empty: ProgressView()
                            case .success(let image):
                                image.resizable()
                                     .scaledToFill()
                                     .frame(maxWidth: .infinity, maxHeight: 140)
                                     .clipped()
                            case .failure: Image(systemName: "photo")
                                     .resizable()
                                     .scaledToFit()
                                     .frame(height: 120)
                                     .foregroundColor(.gray)
                            @unknown default: EmptyView()
                            }
                        }
                        .padding(30)
                        .tag(index)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 140)
                .tabViewStyle(PageTabViewStyle())
                
                if filteredRecipes.isEmpty {
                    VStack {
                        Spacer()
                        Text("No data found")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(filteredRecipes) { recipe in
                            ZStack {

                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                                
                                VStack(spacing: 0) {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.1))
                                        .frame(height: 120)
                                        .overlay(
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
                                        )
                                        .clipped()
                                    

                                    Rectangle()
                                        .fill(AppColors.darkRed)
                                        .frame(height: 36)
                                        .overlay(
                                            Text(recipe.recipeName ?? "Unknown Recipe")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                                .lineLimit(2)
                                                .multilineTextAlignment(.center)
                                        )
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .frame(height: 156)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                            .clipped()
                            .onTapGesture {
                                presenter.navigateDetail(path: $path, recipe: recipe)
                            }
                        }
                    }
                    .padding()
                }
                }
            }
            .onAppear {
                bannerTask = Task {
                    presenter.fetchBanner()
                    presenter.fetchRecipe()
                }
            }.onDisappear {
                bannerTask?.cancel()
                bannerTask = nil
            }.navigationBarBackButtonHidden(true)
            
            if showVoiceSearch {
                ZStack {
                  
                    Color.black.opacity(0.85)
                        .ignoresSafeArea()
                    
                    VoiceSearchSheet { recognizedText in
                        self.searchText = recognizedText
                        self.showVoiceSearch = false
                    } onDismiss: {
                        self.showVoiceSearch = false
                    }
                }
                .transition(.asymmetric(
                    insertion: .opacity.animation(.easeInOut(duration: 0.25)),
                    removal: .opacity.animation(.easeInOut(duration: 0.2))
                ))
            }
        }
        .sheet(isPresented: $showFilter) {
            FilterSheetView { filters in

            }
            .presentationDetents([.large, .large])
        }
    }
}
