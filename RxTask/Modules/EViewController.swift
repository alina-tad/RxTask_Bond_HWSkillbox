//
//  EViewController.swift
//  RxTask
//
//  Created by Alina Topilo on 20.08.2021.
//

import UIKit

class EViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
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
        firstButton.reactive.tap
            .combineLatest(with: secondButton.reactive.tap)
            .observeNext { [weak self] _ in
                guard let self = self else { return }
                self.titleLabel.text = "Ракета запущена"
            }.dispose(in: reactive.bag)
    }

}

/*
 e) Две кнопки и лейбл. Когда на каждую кнопку нажали хотя бы один раз, в лейбл выводится: «Ракета запущена».
*/
