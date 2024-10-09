//
//  ContentView.swift
//  RestaurantApp
//
//  Created by Alexander Gerus on 30.08.2023.
//
import Foundation
import SwiftUI

struct ContentView: View {
    @State private var isPresented: Bool = false
    @Environment(\.presentationMode) var presentationMode
    let screenSize = UIScreen.main.bounds
    @ObservedObject var httpClient = HTTPClient()
    
    var body: some View {
        NavigationView {
            List(self.httpClient.restaurants, id: \.id) { restaurant in
                NavigationLink(destination: RestaurantDetailsView(restaurant: restaurant)) {
                    VStack {
                        restaurant.posterImage()?
                            .resizable()
                            .scaledToFit()
                        
                        Text(restaurant.title!)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .font(.system(size: 25))
                            .cornerRadius(10)
                    } }
            }
            .navigationBarTitle("Restaurants")
            .navigationBarItems(trailing: Button(action: {
                self.isPresented = true
            }){
                Image(systemName: "plus")
            })
            .onAppear {
                self.httpClient.getAllRestaurants()
            }
        }.sheet(isPresented: $isPresented, onDismiss: {
            self.httpClient.getAllRestaurants()
        }, content: {
            AddRestaurantView()
        }) }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
