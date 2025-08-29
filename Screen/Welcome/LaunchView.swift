//
//  LaunchView.swift
//  Recipe
//
//  Created by Gopinath V on 18/08/25.
//
import SwiftUI



struct LaunchView: View {
    
    @StateObject var presenter: LaunchPresenter
    
    @Binding var path: NavigationPath
    
    
    var body: some View {
        VStack {

            Text(AppString.Welcome.title)
                .font(AppFonts.title)
                .foregroundColor(AppColors.textPrimary)
                .padding(.top, 40)
            
            Spacer()
            
            Image(uiImage: AppImages.appLogo.actualImage)
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 220)
                .padding()
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(AppString.Welcome.getStarted)
                    .font(AppFonts.subtitle)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(AppString.Welcome.millionsOfPeople)
                    .font(AppFonts.title)
                    .foregroundColor(AppColors.primary)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            HStack {
                Spacer()
              
                AppButton(title: AppString.Welcome.nextButton) {
                    presenter.navigate(path: $path)
                   
                }.frame(width: 120)
                .padding()
            }.padding()
            
           
        }
        .background(AppColors.background.ignoresSafeArea()).onAppear(perform: {
            Task { [weak presenter] in
                           presenter?.fetchUser()
            }
        }).navigationBarBackButtonHidden()
    }
}

