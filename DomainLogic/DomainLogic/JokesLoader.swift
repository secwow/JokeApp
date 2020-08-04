//
//  JokesLoader.swift
//  CoreLogic
//
//  Created by AndAdmin on 28.07.2020.
//  Copyright © 2020 Andersen. All rights reserved.
//

import Foundation

//{ "type": "success", "value": { "id": , "joke":} }

public protocol JokesLoader {
    typealias Result = Swift.Result<[Joke], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
