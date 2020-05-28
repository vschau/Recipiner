//
//  RecipeTableCell.swift
//  Recipiner
//
//  Created by Vanessa on 5/27/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import Foundation
import UIKit

internal final class RecipeTableCell: UITableViewCell, Cell {
    // Outlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
        thumbnail.image = nil
    }

}
