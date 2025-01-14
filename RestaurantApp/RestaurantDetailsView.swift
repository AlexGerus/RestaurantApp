//
//  RestaurantDetailsView.swift
//  RestaurantApp
//
//  Created by Alexander Gerus on 31.08.2023.
//

import SwiftUI

struct RestaurantDetailsView: View {
    let restaurant: Restaurant
    @State private var reviewTitle: String = ""
    @State private var reviewBody: String = ""
    @ObservedObject private var httpClient = HTTPClient()
    @Environment(\.presentationMode) private var presentationMode
    
    private func deleteRestaurant() {
        HTTPClient().deleteRestaurant(restaurant: restaurant) { success in
            DispatchQueue.main.async {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func saveReview() {
        let review = Review(title: self.reviewTitle, body: self.reviewBody)
        HTTPClient().saveReview(review: review) { success in
            if success {
                // load all the reviews again
                self.httpClient.getReviewsByRestaurant(restaurant: restaurant)
            }
        }
    }
    var body: some View {
        Form {
            restaurant.posterImage()?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            
            Section(header: Text("ADD A REVIEW").fontWeight(.bold)) {
                VStack(alignment: .center, spacing: 10) {
                    TextField("Enter Title",text: $reviewTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Enter Body",text: $reviewBody)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Save") {
                        self.saveReview()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(6.0)
                    .buttonStyle(PlainButtonStyle())
                } }
            Section(header: Text("REVIEWS").fontWeight(.bold)) {
                ForEach(self.httpClient.reviews , id: \.id) { review in
                    Text(review.title)
                }
            }
        }
        .onAppear(perform: {
            // get reviews for restaurant
            self.httpClient.getReviewsByRestaurant(restaurant: restaurant)
        })
        .navigationBarTitle(restaurant.title!)
        .navigationBarItems(trailing: Button(action: {
            self.deleteRestaurant()
        }) {
            Image(systemName: "trash.fill")
        })
        
    }
}

struct RestaurantDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        // base64ImageSmaple1 is a base64 encoded string for a sample image
        RestaurantDetailsView(restaurant: Restaurant(title: "IndieKitchen",
                                                     poster: "123",
                                                     address: "Ashok Vihar Delhi"))
    }
    
}
