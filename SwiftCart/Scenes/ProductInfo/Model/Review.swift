//
//  Review.swift
//  SwiftCart
//
//  Created by Anas Salah on 10/06/2024.
//

import Foundation

struct Review {
    let reviewerName: String
    let reviewDescription: String
    let reviewRating: Double
}

let reviewers = [
    "Ahmed Osman", "Anas Salah", "Isra Muhammed", "Elham Mohammed", "Omar A.Metwally",
    "Eng/ Ahmed Mazen", "Mohamed Galal", "Abdelrhman Mamdouh", "Ahmed Ghonaim", "Ali El-Sayed",
    "Aser Eid", "ENG Esraa Hassan", "ENG Hagar Samir", "Eng.mohamed Galal", "Eng/ Heba",
    "Manal Hamada", "Mina Thabet", "Mohamed Hussein", "Samuel Adel", "Hadi", "Eng/ Safia",
    "Abdelhamed Mohammed", "Mahmoud Osama", "Abdelrahman Sayed", "Asmaa Mohamed", "Aya Mosrafa",
    "Dr.Eman Hesham", "Israa Assem", "Nada Mostafa", "Naden", "Salma Maher", "Walaa Sha3ban",
    "Yasmeen Hosny", "Tasneem Ibrahim", "Ashraf Allam", "M. Mustafa", "Amira", "Mahmoud Ali",
    "Laila Mohamed", "Amira Adel", "Khaled Samir", "Nada Mahmoud", "Sara Essam", "Hassan Ahmed",
    "Youssef Salah", "Rasha Mahmoud", "Ali Hamed", "Salma Khaled", "Omar Hassan", "Anos",
    "Yara Ahmed", "Mai Ali", "Mohamed Mahmoud"
]

let reviewDescriptions = [
    "This product is amazing! I love it.", "Very good quality and fast shipping.", "Not bad, but could be better.",
    "Great product! It exceeded my expectations.", "Quality could be improved, but overall satisfied.",
    "Fast delivery and good customer service.", "Excellent product, highly recommended!",
    "The product arrived late, but it's good quality.", "Amazing product! Worth every penny.",
    "I expected more from this product.", "Decent product, good value for money.",
    "The product was damaged upon arrival.", "Very satisfied with the product and service.",
    "Could be better. Didn't meet my expectations.", "Great product, arrived earlier than expected.",
    "Average product, nothing special.", "Fast shipping, but the product quality is poor.",
    "Excellent service, good product quality.", "Product arrived damaged, disappointed.",
    "Highly recommend this product. Very satisfied.", "Not as described. Disappointed with the product.",
    "Impressed with the quality and delivery speed.", "Average product, nothing exceptional.",
    "Excellent product, exceeded expectations.", "The product didn't meet my expectations.",
    "Fast delivery, good customer service.", "Very satisfied with the purchase. Great product.",
    "The product quality is average.", "Good product overall. Happy with the purchase.",
    "Could be better. Not fully satisfied.", "Great product, but expensive.",
    "Product arrived damaged. Disappointed.", "Excellent service and product quality.",
    "Good quality, fast delivery.", "Not satisfied with the product. Expected better.",
    "The product is good, but overpriced.", "Very happy with the purchase. Excellent product.",
    "Average product, nothing extraordinary.", "The product quality is disappointing.",
    "Highly recommend this product. Very satisfied.", "Not as described. Disappointed with the product.",
    "Impressed with the quality and delivery speed.", "The product quality is average.",
    "Excellent product, exceeded expectations.", "The product didn't meet my expectations.",
    "Fast delivery, good customer service.", "Very satisfied with the purchase. Great product.",
    "The product quality is average.", "Good product overall. Happy with the purchase.",
    "Could be better. Not fully satisfied."
]

func randomReviewDescription() -> String {
    return reviewDescriptions.randomElement() ?? "Good product."
}

func randomReviewRating() -> Double {
    return Double(Int.random(in: 10...50)) / 10.0
}

var dummyReviews: [Review] {
    get{
        reviewers.map { reviewer in
            Review(reviewerName: reviewer, reviewDescription: randomReviewDescription(), reviewRating: randomReviewRating())
        }
    }
}
