//
//  CViewController.swift
//  RxTask
//
//  Created by Alina Topilo on 20.08.2021.
//

import UIKit
import ReactiveKit
import Bond

class CViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    
    //MARK: - Properties
    private var namesArray = Property(["Alex", "Boris", "Calam", "Petr", "Pavel", "Axel", "Axel 2", "Boris 2", "Borya"])
    private var filteredNames = Property([])
    private var randomArray = ["Alex", "Boris", "Calam", "Petr", "Pavel", "Axel", "Axel 2", "Boris 2", "Borya"]
    
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
    private func configureLogic() {
        addButton.reactive.tap.observeNext { [weak self] _ in
            guard let self = self else { return }
            self.namesArray.value.insert(self.randomArray.randomElement() ?? "G", at: 0)
            self.tableView.reloadData()
        }.dispose(in: reactive.bag)
        
        removeButton.reactive.tap
            .observeNext { [weak self] _ in
                guard let self = self else { return }
                if !self.namesArray.value.isEmpty { self.namesArray.value.removeLast() }
                self.tableView.reloadData()
            }.dispose(in: reactive.bag)
        
        namesArray
            .combineLatest(with: filteredNames)
            .compactMap({ self.filteredNames.value.isEmpty == true ? $0 : $1 })
            .bind(to: tableView) { dataSource, indexPath, tableView in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                var content = cell.defaultContentConfiguration()
                content.text = dataSource[indexPath.row] as? String
                cell.contentConfiguration = content
                return cell
            }.dispose(in: reactive.bag)
        
        searchBar.reactive.text
            .throttle(for: 2)
            .debounce(for: 2.5)
            .observeNext { [weak self] text in
                guard let self = self else { return }
                if let text = text {
                    let filtered = self.namesArray.value.filter({ $0.contains(text) })
                    self.filteredNames.value = filtered
                }
            }
            .dispose(in: reactive.bag)
        
        filteredNames.observeNext(with: { [weak self] items in
            guard let self = self else { return }
            if items.isEmpty {
                DispatchQueue.main.async {
                    self.addButton.isHidden = false
                    self.removeButton.isHidden = false
                    self.stackHeight.constant = 40
                }
            } else {
                DispatchQueue.main.async {
                    self.addButton.isHidden = true
                    self.removeButton.isHidden = true
                    self.stackHeight.constant = 0
                }
            }
        }).dispose(in: reactive.bag)
    }
    
}

/*
 c) UITableView с выводом 20 разных имён людей и две кнопки. Одна кнопка добавляет новое случайное имя в начало списка, вторая — удаляет последнее имя. Список реактивно связан с UITableView.
 
 f) Для задачи «c» добавьте поисковую строку. При вводе текста в поисковой строке, если текст не изменялся в течение двух секунд, выполните фильтрацию имён по введённой поисковой строке (с помощью оператора throttle).
 */
