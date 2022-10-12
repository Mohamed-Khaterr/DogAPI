//
//  BreedsList.swift
//  DogAPI
//
//  Created by Khater on 10/12/22.
//

import Foundation


struct BreedsList: Codable{
    let message: [String: [String]]
    let status: String
}
