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
    "Yasmeen Hosny", "Tasneem Ibrahim", "Ashraf Allam", "M. Mustafa", "Amira"
]

func randomReviewDescription(for rating: Double) -> String {
    let roundedRating = Int(round(rating))
    switch roundedRating {
    case 1:
        return [
            "Worst product ever.",
            "Complete waste of money.",
            "Terrible quality, do not buy!",
            "Horrible experience, regret buying.",
            "Absolutely disappointed, do not recommend."
        ].randomElement() ?? "Poor product."
    case 2:
        return [
            "Not satisfied with the product.",
            "Expected more, disappointed.",
            "Below average quality.",
            "Mediocre product, not worth the price.",
            "Disappointing purchase, would not buy again."
        ].randomElement() ?? "Average product."
    case 3:
        return [
            "Decent product, but nothing special.",
            "Okay product, meets expectations.",
            "Fair value for the price.",
            "Reasonable purchase, meets basic needs.",
            "Average quality, nothing remarkable."
        ].randomElement() ?? "Decent product."
    case 4:
        return [
            "Good product, satisfied with the purchase.",
            "Above average quality.",
            "Impressed with the product.",
            "Great value for money, exceeded expectations.",
            "Quality product, would recommend."
        ].randomElement() ?? "Good product."
    case 5:
        return [
            "Excellent product, highly recommended!",
            "Outstanding quality and service.",
            "Couldn't be happier with my purchase!",
            "Top-notch product, exceeded all expectations.",
            "Flawless experience, worth every penny."
        ].randomElement() ?? "Excellent product."
    default:
        return "Decent product, but nothing special."
    }
}



func randomReviewRating() -> Double {
    return Double(Int.random(in: 10...50)) / 10.0
}

var dummyReviews: [Review] {
    get {
        return reviewers.map { reviewer in
            let rating = randomReviewRating()
            return Review(reviewerName: reviewer, reviewDescription: randomReviewDescription(for: rating), reviewRating: rating)
        }
    }
}
