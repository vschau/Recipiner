//
//  UICollectionView+Extension.swift
//  Recipiner
//
//  Created by Vanessa on 5/27/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func isValid(indexPath: IndexPath) -> Bool {
        guard indexPath.section < numberOfSections,
              indexPath.row < numberOfItems(inSection: indexPath.section)
            else { return false }
        return true
    }
}
