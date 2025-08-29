//
//  LoginView.swift
//  Recipe
//
//  Created by Gopinath V on 18/08/25.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var presenter: LoginPresenter
    
    @Binding var path:NavigationPath
    
        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                // Navigation bar
                HStack {
                    Button(action: { path.removeLast() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    Text("SignIn")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hey,")
                        .font(.title)
                        .bold()
                    Text(AppString.Login.loginNow)
                        .font(.title)
                        .bold()
                }
                .padding(.top, 20)
                
                HStack(spacing: 4) {
                    Text("New user,")
                        .foregroundColor(.black)
                    Button(action: {
                        presenter.signupTapped(path: $path)
                    }) {
                        Text(AppString.Login.registerNow)
                            .foregroundColor(AppColors.darkRed)
                            .bold()
                    }
                }
                
                VStack(spacing: 12) {
                    TextField(AppString.Login.userId, text: $presenter.userId)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .keyboardType(.asciiCapable)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                    
                    SecureField(AppString.Login.password, text: $presenter.password)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .padding(.top, 20)
                
                HStack(spacing: 4) {
                    Text("\(AppString.Login.forgetPassword),")
                        .foregroundColor(.black)
                    Button(action: {
                       // presenter.resetPass(path: $path)
                    }) {
                        Text(AppString.Login.resetNow)
                            .foregroundColor(AppColors.darkRed  )
                            .bold()
                    }
                }
                .padding(.top, 10)
                
                HStack {
                    Spacer()
                    Button(action: {
                        presenter.loginTapped(path: $path)
                    }) {
                        Text(AppString.Login.login)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                            .background(AppColors.darkRed)
                            .cornerRadius(8)
                    }
                    .padding(.top, 20)
                    Spacer()
                }.padding(.top, 20)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .navigationBarHidden(true)
            .alert(isPresented: $presenter.showAlert) {
                Alert(title: Text("Login Failed"),
                      message: Text(presenter.alertMessage),
                      dismissButton: .default(Text("OK")))
                    }
        }
    }

    


