//
//  Auth.swift
//  AminiAirlines
//
//  Created by Rose Maina on 17/06/2019.
//  Copyright © 2019 rose maina. All rights reserved.
//

import Foundation

struct Credencials: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}
