//
//  DViewController.swift
//  RxTask
//
//  Created by Alina Topilo on 20.08.2021.
//

import UIKit
import ReactiveKit
import Bond

class DViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    //MARK: - Properties
    private var counter = Property(0)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reactive.bag.dispose()
    }
    
    //MARK: - Configure
    private func configure() {
        addButton.reactive.tap
            .observeNext { [weak self] _ in
                guard let self = self else { return }
                self.counter.value += 1
            }.dispose(in: reactive.bag)
        
        counter
            .map({"\($0)"})
            .bind(to: titleLabel.reactive.text)
            .dispose(in: reactive.bag)
    }

}

/*
 d) Лейбл и кнопку. В лейбле выводится значение counter (по умолчанию 0), при нажатии counter увеличивается на 1.
*/
