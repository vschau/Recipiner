//
//  Recipe+Extension.swift
//  Recipiner
//
//  Created by Vanessa on 5/27/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import Foundation

extension Recipe {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
