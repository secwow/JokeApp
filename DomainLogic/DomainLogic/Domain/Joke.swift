//
//  Joke.swift
//  CoreLogic
//
//  Created by AndAdmin on 28.07.2020.
//  Copyright © 2020 Andersen. All rights reserved.
//

import Foundation

public struct Joke: Hashable {
    public let id: Int
    public let joke: String
    
    public init(with id: Int, joke: String) {
        self.id = id
        self.joke = joke
    }
}
