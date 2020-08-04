//
//  Jokes+Helper.swift
//  DomainLogic
//
//  Created by AndAdmin on 03.08.2020.
//  Copyright © 2020 Andersen. All rights reserved.
//

import Foundation

public extension Joke {
    var local: LocalJoke {
        return LocalJoke(with: id, joke: joke)
    }
}

extension Array where Element == Joke {
    var local: [LocalJoke] {
        return self.map({$0.local})
    }
}
