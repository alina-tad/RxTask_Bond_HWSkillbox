//
//  AViewController.swift
//  RxTask
//
//  Created by Алина Топило on 20.08.2021.
//

import Foundation
import UIKit
import ReactiveKit
import Bond

class AViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var incorrectLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    //MARK: - Properties
    private var correctEmail = "a@gmail.com"
    private var correctPass = "123456"
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureLogic()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reactive.bag.dispose()
    }
    
    //MARK: - Configure
    func configureLogic() {
        combineLatest(emailTextField.reactive.text, passwordTextField.reactive.text) { email, pass in
            return (email?.count ?? 0) > 5 && (pass?.count ?? 0) > 5
        }
        .bind(to: sendButton.reactive.isEnabled)
        .dispose(in: reactive.bag)
        
        emailTextField.reactive.text
            .combineLatest(with: passwordTextField.reactive.text)
            .filter { email, pass in (email?.count ?? 0) > 3 || (pass?.count ?? 0) > 3}
            .map { $0 == self.correctEmail ? ($1 == self.correctPass ? "" : "incorrect pass") : "incorrect email" }
            .debounce(for: 0.5)
            .bind(to: incorrectLabel.reactive.text)
            .dispose(in: reactive.bag)
        
        sendButton.reactive.tap.observeNext {
            print("Great!")
        }.dispose(in: reactive.bag)
    }
    
}

/*
 a) Два текстовых поля. Логин и пароль, под ними лейбл и ниже кнопка «Отправить». В лейбл выводится «некорректная почта», если введённая почта некорректна. Если почта корректна, но пароль меньше шести символов, выводится: «Слишком короткий пароль». В противном случае ничего не выводится. Кнопка «Отправить» активна, если введена корректная почта и пароль не менее шести символов.
 */
