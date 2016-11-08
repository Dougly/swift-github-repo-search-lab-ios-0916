//
//  ViewController.swift
//  swift-github-repo-search-lab
//
//  Created by Ian Rahman on 10/24/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    let store = DataStore.dataStore
    
    let alertView = UIAlertController(title: "Alert!", message: "Hi", preferredStyle: .alert)
    let searchAlertView = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        self.present(searchAlertView, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        GithubAPIClient.populateDataStoreWithRepos {
            self.tableView.reloadData()
        }
        
        setUpAlertViews()
        
        
    }
    
    func setUpAlertViews() {
        let oKAction = UIAlertAction(title: "Okay", style: .default) { clicked in
            self.alertView.dismiss(animated: true, completion: nil)
        }
        alertView.addAction(oKAction)
        
        searchAlertView.addTextField { (textField) in
            textField.placeholder = "enter something to search"
        }
        
        let searchAction = UIAlertAction(title: "GO", style: .default) { clicked in
            let searchField = (self.searchAlertView.textFields?[0])! as UITextField
            
            let query = searchField.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            print(query)
            
            if let query = query {
                GithubAPIClient.searchForRepo(input: query) {
                    self.tableView.reloadData()
                }
            }
            self.alertView.dismiss(animated: true, completion: nil)
            
        }
        searchAlertView.addAction(searchAction)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "repoCell")
        cell?.textLabel?.text = store.repositories[indexPath.row].fullName
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let repo = store.repositories[indexPath.row].fullName
        
        GithubAPIClient.checkIfDouglyStarred(repo: repo) { isStarred in
            
            if isStarred {
                GithubAPIClient.unstar(repo: repo) {
                    self.presentAlert(success: isStarred, repoName: repo)
                }
            } else if !isStarred {
                GithubAPIClient.star(repo: repo) {
                    self.presentAlert(success: isStarred, repoName: repo)
                }
            }
        }
    }
    
    
    func presentAlert(success: Bool, repoName: String) {
        
        if !success {
            alertView.message = "\(repoName) was starred!"
        } else {
            alertView.message = "\(repoName) was un-starred"
        }
        self.present(alertView, animated: true, completion: nil)
    }
}
