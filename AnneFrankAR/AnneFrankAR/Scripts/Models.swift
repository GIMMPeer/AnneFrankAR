//
//  Models.swift
//  AnneFrankAR
//
//  Created by Tri Nguyen on 4/15/22.
//

import Foundation
import RealityKit

/*
 Constructor for parsing Json Data
 Naming in struct have to match with json object
*/
struct ContentData: Codable {
    let data: [ContentItem]
}

struct ContentItem: Codable {
    let title: String
    let unlocked: Bool
    let pageData: [PageItem]
}

struct PageItem: Codable {
    let title: String
    let context: String
    let image: String
    let video: String
}
