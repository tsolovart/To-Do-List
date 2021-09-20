//
//  User.swift
//  toDoList
//
//  Created by Zaoksky on 20.09.2021.
//

import Foundation
import Firebase

// [7] Модель пользователя
struct User {
    
    let uid: String
    let email: String
    
    // [7] Получение пользователя. Нужен для извлечения uid и email для работы локально
    init(user: Firebase.User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
