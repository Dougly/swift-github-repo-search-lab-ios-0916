//
//  DataStore.swift
//  swift-github-repo-search-lab
//
//  Created by Douglas Galante on 11/7/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class DataStore {
    static let dataStore = DataStore()
    var repositories: [GithubRepo] = []
    
    fileprivate init () {}
    
}

