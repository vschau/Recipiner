//
//  DetailViewController.swift
//  Recipiner
//
//  Created by Vanessa on 5/26/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ingredientTextView: UITextView!
    @IBOutlet weak var InstructionTextView: UITextView!
    var recipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = recipe.title
        if let img = recipe.img {
            imageView.image = UIImage(data: img)
        }
        ingredientTextView.text = recipe.ingredients
        InstructionTextView.text = recipe.instructions
    }


}
