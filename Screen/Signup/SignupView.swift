//
//  SignupView.swift
//  Recipe
//
//  Created by Gopinath V on 18/08/25.
//

import SwiftUI


struct SignupView: View {
    
    @StateObject var presenter: SignupPresenter
    
    @Binding var path:NavigationPath
    
    @Environment(\.dismiss) var dismiss
     
    
    var body: some View {
        
        VStack(spacing: 20) {
            // Navigation bar
            HStack {
                Button(action: { path.removeLast() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                Spacer()
                Text("Register an account")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
        
            if presenter.yesNavigationBack {
                            Color.clear
                                .onAppear {
                                    dismiss()
                    }
                }
                
                Group {
                    CustomTextField(placeholder: "User Id", text: $presenter.userId, isSecure: false)
                        .keyboardType(.asciiCapable)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                    
                    CustomTextField(placeholder: "Password", text: $presenter.password, isSecure: true)
                    CustomTextField(placeholder: "Confirm Password", text: $presenter.confirmPassword, isSecure: true)
                }
                .padding(.horizontal, 30)
                
                Button(action: {
                    presenter.registerTapped()
                   // presenter.moveToDashBoard(path: $path)
                }) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(AppColors.darkRed)
                        .cornerRadius(6)
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
                
                Spacer()
                
                HStack(spacing: 5) {
                    Text("Already have an account?")
                        .foregroundColor(.black)
                    Button(action: {
                        print("Sign In tapped")
                    }) {
                        Text("Sign in")
                            .foregroundColor(AppColors.darkRed)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.bottom, 20)
            }
            .navigationBarBackButtonHidden(false)
            .navigationBarHidden(true)
            .alert(isPresented: $presenter.isShowAlert) {
                Alert(title: Text("Registerd Account Sucess"),
                      message: Text(presenter.alertMessage),
                      dismissButton: .default(Text("OK")){
                    dismiss()
                })
            }
        
        
        }

}
