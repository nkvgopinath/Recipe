//
//  ProfileView.swift
//  Recipe
//
//  Created by Gopinath V on 20/08/25.
//

import Foundation
import SwiftUI
import Combine
import PhotosUI

struct ProfileView: View {
    @UserDefault(key: "userName")
    private var username: String?

    @UserDefault(key: "userPhone")
    private var phone: String?

    @UserDefault(key: "userCity")
    private var city: String?

    @UserDefault(key: "userCuisine")
    private var favouriteCuisine: String?
    
    @UserDefault(key: "profileImageData")
    private var profileImageData: Data?
    
    @State private var selectedImage: PhotosPickerItem?
    @State private var profileImage: UIImage?
    @State private var showImagePicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showSuccessMessage = false
    
    @Binding var path: NavigationPath
    var apiManager: APIManager

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Image Section
                VStack(spacing: 16) {
                    ZStack(alignment: .bottomTrailing) {
                        // Profile Image Display
                        Group {
                            if let profileImage = profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            } else if let imageData = profileImageData, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            } else {
                                Image(uiImage: AppImages.appLogo.actualImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            }
                        }
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .overlay(
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        
                        // Camera button overlay
                        PhotosPicker(selection: $selectedImage, matching: .images) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .frame(width: 32, height: 32)
                                .background(AppColors.darkRed)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                        .offset(x: 8, y: 8)
                    }
                    
                    Text("Tap camera to change photo")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)

                // Profile Information Section
                VStack(spacing: 12) {
                    // Name Field
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Full Name")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        TextField("Enter your name", text: Binding(
                            get: { username ?? "" },
                            set: { username = $0 }
                        ))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }

                    // Phone Field
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Phone Number")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        TextField("Enter your phone number", text: Binding(
                            get: { phone ?? "" },
                            set: { phone = $0 }
                        ))
                        .multilineTextAlignment(.center)
                        .keyboardType(.phonePad)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }

                    // City Field
                    VStack(alignment: .leading, spacing: 4) {
                        Text("City")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        TextField("Enter your city", text: Binding(
                            get: { city ?? "" },
                            set: { city = $0 }
                        ))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }

                    // Favourite Cuisine Field
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Favourite Cuisine")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        TextField("Enter your favourite cuisine", text: Binding(
                            get: { favouriteCuisine ?? "" },
                            set: { favouriteCuisine = $0 }
                        ))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 20)

                Spacer(minLength: 40)

                // Action Buttons
                VStack(spacing: 16) {
                    // Save Button
                    Button("Save Changes") {
                        saveProfile()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(AppColors.darkRed)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .font(.headline)
                    .shadow(color: AppColors.darkRed.opacity(0.3), radius: 4, x: 0, y: 2)

                    // Logout Button
                    Button("Logout") {
                        username = ""
                        phone = ""
                        city = ""
                        favouriteCuisine = ""
                        profileImageData = nil
                        apiManager.deleteUser()
                        apiManager.deleteAll()
                        
                        // Clear navigation path and go to launch screen
                        path = NavigationPath(["Launch"])
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(.red)
                    .cornerRadius(12)
                    .font(.headline)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemGroupedBackground))
        .onChange(of: selectedImage) { newItem in
            Task {
                if let newItem = newItem,
                   let data = try? await newItem.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    profileImage = uiImage
                }
            }
        }
        .alert("Profile Update", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .overlay(
            Group {
                if showSuccessMessage {
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Profile saved successfully!")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(radius: 4)
                        .padding(.bottom, 50)
                    }
                    .transition(.opacity)
                }
            }
        )
    }
    
    private func saveProfile() {
        // Validate required fields
        guard let name = username, !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Please enter your name"
            showAlert = true
            return
        }
        
        if let image = profileImage,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            profileImageData = imageData
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            showSuccessMessage = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showSuccessMessage = false
            }
        }
        
        print("Profile saved - Name: \(username ?? ""), Phone: \(phone ?? ""), City: \(city ?? ""), Cuisine: \(favouriteCuisine ?? "")")
    }
}
