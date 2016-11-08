//
//  GithubAPIClient.swift
//  swift-github-repo-search-lab
//
//  Created by Douglas Galante on 11/2/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import Alamofire



class GithubAPIClient {
    
    let store = DataStore.dataStore
    
    class func populateDataStoreWithRepos(completion: @escaping () -> Void) {

        
        Alamofire.request("https://api.github.com/repositories?client_id=\(Secrets.githubClientID)&client_secret=\(Secrets.githubSecretID)").responseJSON { response in
            
            if let JSON = response.result.value {
                let data = JSON as! [[String:Any]]
                for repo in data {
                    let fullName = repo["full_name"] as! String
                    DataStore.dataStore.repositories.append(GithubRepo(fullName: fullName))
                }
                completion()
            }
        }
    }
    
    class func checkIfDouglyStarred(repo fullName: String, completion: @escaping (Bool)->Void) {
        
        Alamofire.request("https://api.github.com/user/starred/\(fullName)?access_token=\(Secrets.personalAccessToken)").responseJSON { (response) in
            
            if let statusCode = response.response?.statusCode {
                
                switch statusCode {
                case 404:
                    completion(false)
                case 204:
                    completion(true)
                default:
                    break
                    
                }
            }
        }
    }
    
    class func star(repo fullName: String, completion: @escaping () -> Void) {
        
        
        let url = "https://api.github.com/user/starred/\(fullName)?access_token=\(Secrets.personalAccessToken)"
        
        let headers: HTTPHeaders = ["Content-Length": "0"]
        
        Alamofire.request(url, method: .put, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            completion()
        }
        
    }
    
    class func unstar(repo fullName: String, completion: @escaping () -> Void) {
        Alamofire.request("https://api.github.com/user/starred/\(fullName)?access_token=\(Secrets.personalAccessToken)", method: .delete).responseJSON { (response) in
            completion()
        }
    }
    
    class func searchForRepo(input: String, completion: @escaping () -> Void) {
        Alamofire.request("https://api.github.com/search/repositories?q=\(input)").responseJSON { (response) in
            
            if let JSON = response.result.value {
                DataStore.dataStore.repositories = []
                let data = JSON as! [String:Any]
                let items = data["items"] as! [[String:Any]]
                for repo in items {
                    let fullName = repo["full_name"] as! String
                    DataStore.dataStore.repositories.append(GithubRepo(fullName: fullName))
                }
                completion()
            }
        }
    }
}
