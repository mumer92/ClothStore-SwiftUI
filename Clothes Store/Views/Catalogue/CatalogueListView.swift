//
//  CatalogueListView.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 24/07/2022.
//  Copyright © 2022 MuhammadUmer. All rights reserved.
//

import SwiftUI

struct CatalogueListView: View {
    @StateObject var viewModel: ViewModel
    
    @State var shouldNavigate = false
    var selectedProduct: Product?
    
    var columns: [GridItem] = [
        GridItem(.flexible(minimum: 100, maximum: 180), spacing: 20),
        GridItem(.flexible(minimum: 100, maximum: 180), spacing: 20),
    ]
    
    fileprivate func extractedFunc(_ product: Product) -> CatalogueListItemView {
        return CatalogueListItemView(product: product, viewModel: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if !viewModel.isLoading {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.products) { product in
                                extractedFunc(product)
                                    .padding(.bottom, 20)
                                    .onTapGesture {
                                        viewModel.hapticFeedback()
                                        viewModel.selectedProduct = product
                                        shouldNavigate.toggle()
                                    }
                                    .sheet(isPresented: $shouldNavigate) {
                                        if let selectedProduct = viewModel.selectedProduct {
                                            ProductDetailView(viewModel: viewModel, product: selectedProduct)
                                        }
                                    }
                            }
                        }
                    }
                    
                } else {
                    ProgressView()
                        .frame(height: 20)
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.primaryColour))
                }
            }
            .padding(.top, 10)
            .navigationTitle("Catalogue")
        }
        .alert(isPresented: $viewModel.isError) {
            Alert(title: Text("Error"),
                  message: Text("There has been an error getting the data. Please check your network connection and try again"),
                  dismissButton: .default(
                    Text("Retry"), action: {
                        //viewModel.fetchProducts()
                    }
                  )
            )
        }
        .environment(\.colorScheme, .light)
    }
}

struct CatalogueListView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogueListView(viewModel: ViewModel())
    }
}
