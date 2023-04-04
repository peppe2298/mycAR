//
//  ExploreItem.swift
//  mycAR
//
//  Created by Giuseppe Moramarco on 09/12/22.
//

import Foundation

struct ExploreItem {
    let name: String?
    let image: String?
}

extension ExploreItem {
    init(dict: [String: String]) {
        self.name = dict["name"]
        self.image = dict["image"]
    }
}
