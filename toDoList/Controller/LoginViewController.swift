//
//  ViewController.swift
//  toDoList
//
//  Created by Zaoksky on 13.09.2021.
//

// [5] Работа к Keyboard, Scroll
// [6] Аутентификация пользователя - регистрация. Firebase - возможность входа для пользователя.

import UIKit
import Firebase

class LoginViewController: UIViewController {

    let segueIdentifier = "tasksSegue"
    
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
        
        warnLabel.alpha = 0
        
        // [6] Проверка изменения пользователя, чтобы снова не входить и не регистрироваться. Если нет, оставаться в приложении
        FirebaseAuth.Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: nil)
            }
        }
    }
    
    // [6] Удаление данных в тектовых полях. При загрузке приложения, перед тем как отобразится View
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
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
    
    // [6] Отображение warningLabel "User does not exist"
    func displayWarningLabel(withText text: String) {
        warnLabel.text = text
        
        // [6] Анимация - надпись появится на 3 секунды
        // [6] * self?.warnLabel - цикл сильных ссылок. [weak self] in - позволяет избежать этого
        UIView.animate(withDuration: 3,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut) { [weak self] in
            self?.warnLabel.alpha = 1
        } completion: { [weak self] comlete in
            self?.warnLabel.alpha = 0
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        // [6] Проверка полей на наличие информации
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              email != "",
              password != ""
        else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        
        // [6] Вход. Залогиниться
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
            if error != nil {
                self?.displayWarningLabel(withText: "Error occured")
                return
            }
            
            // [6] Существует ли такой пользователь с email. И переход на следующий View
            if user != nil {
                self?.performSegue(withIdentifier: "tasksSegue", sender: nil)
                return
            }
            
            self?.displayWarningLabel(withText: "No such user")
        })
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        // [6] Регистарция в тех же полях email и password
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              email != "",
              password != ""
        else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                if user != nil {
            
                } else {
                    print("User isn't created")
                }
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    
}

