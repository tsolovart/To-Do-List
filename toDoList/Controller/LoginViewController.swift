//
//  ViewController.swift
//  toDoList
//
//  Created by Zaoksky on 13.09.2021.
//

// [5] Работа к Keyboard, Scroll

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [5] Привызка величины Scroll к величине Кeyboard, так как последняя перекрывает контент
        // [5] Узнаем величину Keyboard и узнаем появление Keyboard -> use Notification
        // [5] Класс будет наблюдателем -> self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    // [5] Отслеживание уведомления name: UIResponder.keyboardDidShowNotification и происходит отработка метода
    // [5] Notification хранит информацию о размере клавиатуры
    // [5] Заменяем UIView на IUScrollView в Storyboard
    @objc func keyboardDidShow(notification: Notification) {
        
        // [5] Словарь с инфомацией
        guard let userInfo = notification.userInfo else { return }
        
        // [5] Размер Keyboard из словаря
        // [5] Кастим *(приводим к типу) от Any до NSValue, а после до CGRect
        let keyboardFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        // [5] Изменение размера контекта для Scroll
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + keyboardFrameSize.height)
        
        // [5] Изменение индикатора, чтобы он не уходил за клавиатуру
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrameSize.height, right: 0)
    }
    
    // [5] Уход клавиатуры
    @objc func keyboardDidHide() {
        // [5] Возвращение размера контекта до исходного
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
    }
    
}

