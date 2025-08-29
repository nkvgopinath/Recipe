//
//  UserDefaultWrapper.swift
//  Recipe
//
//  Created by Gopinath V on 21/08/25.
//

import SwiftUI


@propertyWrapper
struct UserDefault<T> {
    let key: String

    var wrappedValue: T? {
        get {
            UserDefaults.standard.object(forKey: key) as? T
        }
        nonmutating set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
}


extension UserDefaults {
    static func clearKeys(_ keys: [String]) {
        let defaults = UserDefaults.standard
        keys.forEach { defaults.removeObject(forKey: $0) }
    }
}
