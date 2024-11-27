//
//  ZoomImageView.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 12.11.2024.
//

import SwiftUI
import Kingfisher

@MainActor
struct ZoomImageScreen: View {
    private let mainNavigation = EnvironmentObjects.navigation
    var imageToZoom: String?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                BackButton(imageColor: .white) {
                    mainNavigation?.pop(animated: true)
                }
                Spacer()
            }.padding([.top, .horizontal], 16)
            
            GeometryReader { geometry in
                if let image = imageToZoom {
                    zoomableImageView(imageURL: image, geometry: geometry)
                    
                }
            }
        }.background(Color.black)
    }
    
    private func zoomableImageView(imageURL: String, geometry: GeometryProxy) -> some View {
        ZoomableScrollView {
//                    let localPath = avatarUrl
//                    KFImage(URL(string: "file://\(localPath)"))
            KFImage(URL(string: imageURL))
                .resizable()
                .placeholder {
                    Image(.imgPlaceholder)
                        .resizable()
                }
                .scaledToFit()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
        }.frame(width: geometry.size.width, height: geometry.size.height)
    }
}
