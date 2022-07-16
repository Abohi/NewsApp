//
//  ViewController.swift
//  NewsApp
//
//  Created by Evans Abohi on 16/07/2022.
//
//TableView
// Custom Cell
//Api Caller
//Open the News Story
//Search for news
//
import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    private let tableView: UITableView={
        let table=UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.indentifier)
        return table;
    }()
    private var viewModels=[NewsTableViewCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title="News"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        APICaller.shared.getTopStories { [weak self] result in
            switch result{
            case .success(let response):
                self?.viewModels = response.compactMap({
                    NewsTableViewCellViewModel(title: $0.title, subtitle:$0.description, imageURL: URL(string: $0.urlToImage))
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame=view.bounds
    }
 
    //Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.indentifier,for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        
        cell.configure(with: viewModels[indexPath.row])
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

