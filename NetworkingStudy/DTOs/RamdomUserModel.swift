//
//  RamdomUserModel.swift
//  NetworkingStudy
//
//  Created by 장은석 on 8/16/25.
//

import Foundation

struct RamdomUserModel: Decodable {
    
    let name: [String: String]
    let email: String
    let picture: [String: String]
}
