//
//  LaunchRouterProtocol.swift
//  Recipe
//
//  Created by Gopinath V on 18/08/25.
//

import Foundation
import SwiftUI

protocol LaunchRouterProtocol {
    func navigateLogin(path: Binding<NavigationPath>)
    func navigateHome(path: Binding<NavigationPath>)

}

class LaunchRouter: LaunchRouterProtocol {
    
    func navigateHome(path: Binding<NavigationPath>) {
        path.wrappedValue.append("Home")
    }
    
    func navigateLogin(path: Binding<NavigationPath>) {
           path.wrappedValue.append("Login") 
       }
}
