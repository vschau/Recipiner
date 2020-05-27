//
//  ErrorResponse.swift
//  Recipiner
//
//  Created by Vanessa on 5/27/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable, Error {
    let status: String
    let code: Int
    let message: String
}
