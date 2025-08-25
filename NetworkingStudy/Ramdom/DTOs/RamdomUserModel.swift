//
//  RamdomUserModel.swift
//  NetworkingStudy
//
//  Created by 장은석 on 8/16/25.
//

import Foundation

struct RamdomUserModel: Decodable {
    
    let name: Name
    let email: String
    let picture: Picture
}

/// 이름
struct Name: Decodable {
    let title: String
    let first: String
    let last: String
}

/// 사진
struct Picture: Decodable {
    let large: String
    let medium: String
    let thumbnail: String
}
