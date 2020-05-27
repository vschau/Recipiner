//
//  RecipeResponse.swift
//  Recipiner
//
//  Created by Vanessa on 5/26/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import Foundation

typealias RecipeDic = [String: String?]

// MARK: - RecipeResponse
struct RecipeResponse: Codable {
    // dictionary: [String: String?]
    let meals: [RecipeDic]
}

//struct RecipeResponse: Codable {
//    let meals: [Meal]
//}

// MARK: - Meal
//struct Meal: Codable {
//    let idMeal, strMeal: String
//    let strDrinkAlternate: String?
//    let strCategory, strArea, strInstructions: String
//    let strMealThumb: String
//    let strTags: String?
//    let strYoutube, strSource: String
//    let strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6, strIngredient7,
//    let dateModified: String?
//}

