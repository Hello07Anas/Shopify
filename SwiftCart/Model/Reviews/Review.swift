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

let dummyReviews: [Review] = [
    Review(reviewerName: "Ahmed Osman", reviewDescription: "This product is amazing! I love it.", reviewRating: 4.5),
    Review(reviewerName: "Anas Salah", reviewDescription: "Very good quality and fast shipping.", reviewRating: 5.0),
    Review(reviewerName: "Isra Muhammed", reviewDescription: "Not bad, but could be better.", reviewRating: 4.5),
    Review(reviewerName: "Elham", reviewDescription: "This product is amazing! Very satisfied.", reviewRating: 5.0),
    Review(reviewerName: "Omar A.Metwally", reviewDescription: "Very good quality and fast shipping.", reviewRating: 5.0),
    Review(reviewerName: "Eng/ Ahmed Mazen", reviewDescription: "Not bad, but could be better.", reviewRating: 3.0),
    Review(reviewerName: "Mohamed Galal", reviewDescription: "Great product! It exceeded my expectations.", reviewRating: 4.0),
    Review(reviewerName: "Abdelrhman Mamdouh", reviewDescription: "Quality could be improved, but overall satisfied.", reviewRating: 3.5),
    Review(reviewerName: "Ahmed Ghonaim", reviewDescription: "Fast delivery and good customer service.", reviewRating: 4.5),
    Review(reviewerName: "Ali El-Sayed", reviewDescription: "Excellent product, highly recommended!", reviewRating: 5.0),
    Review(reviewerName: "Aser Eid", reviewDescription: "The product arrived late, but it's good quality.", reviewRating: 3.0),
    Review(reviewerName: "ENG Esraa Hassan", reviewDescription: "Amazing product! Worth every penny.", reviewRating: 5.0),
    Review(reviewerName: "ENG Hagar Samir", reviewDescription: "I expected more from this product.", reviewRating: 2.5),
    Review(reviewerName: "Eng.mohamed Galal", reviewDescription: "Decent product, good value for money.", reviewRating: 4.0),
    Review(reviewerName: "Eng/ Heba", reviewDescription: "The product was damaged upon arrival.", reviewRating: 1.5),
    Review(reviewerName: "Manal Hamada", reviewDescription: "Very satisfied with the product and service.", reviewRating: 4.5),
    Review(reviewerName: "Mina Thabet", reviewDescription: "Could be better. Didn't meet my expectations.", reviewRating: 3.0),
    Review(reviewerName: "Mohamed Hussein", reviewDescription: "Great product, arrived earlier than expected.", reviewRating: 4.5),
    Review(reviewerName: "Samuel Adel", reviewDescription: "Average product, nothing special.", reviewRating: 3.0),
    Review(reviewerName: "Hadi", reviewDescription: "Fast shipping, but the product quality is poor.", reviewRating: 2.0),
    Review(reviewerName: "Eng/ Safia", reviewDescription: "Excellent service, good product quality.", reviewRating: 4.5),
    Review(reviewerName: "Abdo", reviewDescription: "Product arrived damaged, disappointed.", reviewRating: 1.0),
    Review(reviewerName: "Mahmoud Osama", reviewDescription: "Highly recommend this product. Very satisfied.", reviewRating: 5.0),
    Review(reviewerName: "Abdelrahman Sayed", reviewDescription: "Not as described. Disappointed with the product.", reviewRating: 2.0),
    Review(reviewerName: "Asmaa Mohamed", reviewDescription: "Impressed with the quality and delivery speed.", reviewRating: 4.5),
    Review(reviewerName: "Aya Mosrafa", reviewDescription: "Average product, nothing exceptional.", reviewRating: 3.0),
    Review(reviewerName: "Dr.Eman Hesham", reviewDescription: "Excellent product, exceeded expectations.", reviewRating: 5.0),
    Review(reviewerName: "Israa Assem", reviewDescription: "The product didn't meet my expectations.", reviewRating: 2.5),
    Review(reviewerName: "Nada Mostafa", reviewDescription: "Fast delivery, good customer service.", reviewRating: 4.0),
    Review(reviewerName: "Naden", reviewDescription: "Very satisfied with the purchase. Great product.", reviewRating: 4.5),
    Review(reviewerName: "Salma Maher", reviewDescription: "The product quality is average.", reviewRating: 3.0),
    Review(reviewerName: "Walaa Sha3ban", reviewDescription: "Good product overall. Happy with the purchase.", reviewRating: 4.0),
    Review(reviewerName: "Yasmeen Hosny", reviewDescription: "Could be better. Not fully satisfied.", reviewRating: 3.0),
    Review(reviewerName: "Tasneem ibrahim", reviewDescription: "Great product, but expensive.", reviewRating: 4.0),
    Review(reviewerName: "Ashraf Allam", reviewDescription: "Product arrived damaged. Disappointed.", reviewRating: 1.5),
    Review(reviewerName: "M. Mustafa", reviewDescription: "Excellent service and product quality.", reviewRating: 5.0),
    Review(reviewerName: "Amira", reviewDescription: "Good quality, fast delivery.", reviewRating: 4.5),
    Review(reviewerName: "Mahmoud Ali", reviewDescription: "Not satisfied with the product. Expected better.", reviewRating: 2.0),
    Review(reviewerName: "Laila Mohamed", reviewDescription: "The product is good, but overpriced.", reviewRating: 3.5),
    Review(reviewerName: "Amira Adel", reviewDescription: "Very happy with the purchase. Excellent product.", reviewRating: 5.0),
    Review(reviewerName: "Khaled Samir", reviewDescription: "Average product, nothing extraordinary.", reviewRating: 3.0),
    Review(reviewerName: "Nada Mahmoud", reviewDescription: "The product quality is disappointing.", reviewRating: 1.0),
    Review(reviewerName: "Sara Essam", reviewDescription: "Highly recommend this product. Very satisfied.", reviewRating: 5.0),
    Review(reviewerName: "Hassan Ahmed", reviewDescription: "Not as described. Disappointed with the product.", reviewRating: 2.0),
    Review(reviewerName: "Youssef Salah", reviewDescription: "Impressed with the quality and delivery speed.", reviewRating: 4.5),
    Review(reviewerName: "Rasha Mahmoud", reviewDescription: "Average product, nothing exceptional.", reviewRating: 3.0),
    Review(reviewerName: "Ali Hamed", reviewDescription: "Excellent product, exceeded expectations.", reviewRating: 5.0),
    Review(reviewerName: "Salma Khaled", reviewDescription: "The product didn't meet my expectations.", reviewRating: 2.5),
    Review(reviewerName: "Omar Hassan", reviewDescription: "Fast delivery, good customer service.", reviewRating: 4.0),
    Review(reviewerName: "Anos", reviewDescription: "Very satisfied with the purchase. Great product.", reviewRating: 4.5),
    Review(reviewerName: "Yara Ahmed", reviewDescription: "The product quality is average.", reviewRating: 3.0),
    Review(reviewerName: "Mai Ali", reviewDescription: "Good product overall. Happy with the purchase.", reviewRating: 4.0),
    Review(reviewerName: "Mohamed Mahmoud", reviewDescription: "Could be better. Not fully satisfied.", reviewRating: 3.0),
]
