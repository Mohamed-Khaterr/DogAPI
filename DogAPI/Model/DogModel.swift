//
//  DogModel.swift
//  DogAPI
//
//  Created by Khater on 10/7/22.
//

import Foundation


struct DogModel: Codable{
    let message: String
    let status: String
    
    var url: URL? {
        get {
            let urlString = message
            return URL(string: urlString)
        }
    }
}
