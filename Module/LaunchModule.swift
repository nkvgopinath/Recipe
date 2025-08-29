//
//  LaunchModule.swift
//  Recipe
//
//  Created by Gopinath V on 18/08/25.
//

import  SwiftUI


struct LaunchModule {
    static func build(path: Binding<NavigationPath>,apiManager: APIManager) -> some View {
        
        let router = LaunchRouter()
        let interactor = LaunchInteractor(apiManager: apiManager)
         let presenter = LaunchPresenter(interactor: interactor, router: router)
         return LaunchView(presenter: presenter, path: path)
     }
}
