//
//  CatalogueListItemView.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 24/07/2022.
//  Copyright © 2022 MuhammadUmer. All rights reserved.
//

import SwiftUI
import Combine

struct CatalogueListItemView: View {
    @StateObject var product: Product
    @StateObject var viewModel: ViewModel
    
    @State var image: UIImage?
    @State var cancellable: [AnyCancellable] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 130, maxHeight: 130)
                } else {
                    Image(systemName: "photo")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.primaryColour)
                        .frame(maxWidth: 130, maxHeight: 130)
                }
            }
            .overlay(
                Image(systemName: viewModel.isAddedToWishlist(product: product) ? "suit.heart.fill" : "suit.heart")
                    .foregroundColor(.primaryColour)
                    .frame(width: 40, height: 40, alignment: .topTrailing)
                    .onTapGesture {
                        viewModel.updateWishlist(product: product)
                    },
                alignment: .topTrailing)
            
            Spacer()
            
            Text(product.name ?? "")
                .font(.custom("HelveticaNeue-Light", size: 14))
                .foregroundColor(.gray.opacity(0.8))
                .frame(height: 40, alignment: .leading)
            
            Text(CurrencyHelper.getMoneyString(product.price?.floatValue ?? 0))
                .font(.custom("HelveticaNeue-Bold", size: 18))
                .foregroundColor(.black.opacity(0.9))
                .frame(height: 27, alignment: .leading)
        }
        .foregroundColor(.black)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.black.opacity(0.1), lineWidth: 1)
        )
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.white))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let image = product.image else { return }
        
        viewModel.downloadImage(url: image)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { image in
                self.image = image
            }.store(in: &cancellable)
    }
}
