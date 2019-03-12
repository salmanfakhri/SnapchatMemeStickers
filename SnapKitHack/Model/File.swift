//
//  File.swift
//  SnapKitHack
//
//  Created by Salman Fakhri on 3/10/19.
//  Copyright © 2019 Salman Fakhri. All rights reserved.
//

import Foundation

struct RedditResponse: Codable {
    let kind: String
    let data: RedditResponseData
    
    struct RedditResponseData: Codable {
        let children: [Child]
        
        struct Child: Codable {
            let data: ChildData
            
            struct ChildData: Codable {
                let title: String
                let url: String
            }
        }
    }
}
