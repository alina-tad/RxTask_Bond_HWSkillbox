//
//  BViewController.swift
//  RxTask
//
//  Created by Alina Topilo on 20.08.2021.
//

import UIKit
import ReactiveKit
import Bond

class BViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var titleLabel: UILabel!
    
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
        searchBar.reactive.text
            .filter { ($0?.count ?? 0) > 2 }
            .ignoreNils()
            .debounce(for: 0.5)
            .observeNext { text in
                print("Отправка запроса для \(text)")
            }.dispose(in: reactive.bag)
    }

}

/*
 b) Текстовое поле для ввода поисковой строки. Реализуйте симуляцию «отложенного» серверного запроса при вводе текста: если не было внесено никаких изменений в текстовое поле в течение 0,5 секунд, то в консоль должно выводиться: «Отправка запроса для <введенный текст в текстовое поле>».
 */
