//
//  AppImages.swift
//  Recipe
//
//  Created by Gopinath V on 19/08/25.
//

import SwiftUI

enum AppImages:String  {
     
    case appLogo = "app_logo"
    
    
    var actualImage: UIImage {
        UIImage(named: self.rawValue) ?? UIImage()
    }
    
}
