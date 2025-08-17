//
//  RamdomUserResponseDTO.swift
//  NetworkingStudy
//
//  Created by 장은석 on 8/16/25.
//

import Foundation

struct RamdomUserResponseDTO: Decodable {
    
    /// 검색된 GitHub 사용자 DTO 목록
    let results: [RamdomUserModel]
}
