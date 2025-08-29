//
//  AppButton.swift
//  Recipe
//
//  Created by Gopinath V on 19/08/25.
//

import SwiftUI

struct AppButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .font(AppFonts.subtitle)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(AppColors.darkRed)
                .cornerRadius(12)
                .shadow(radius: 3).padding()
        }
    }
}
