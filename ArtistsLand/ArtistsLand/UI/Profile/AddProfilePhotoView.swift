//
//  AddProfilePhotoView.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 06.11.2024.
//

import SwiftUI

struct AddProfilePhotoView: View {
    let title: String
    let buttonText: String
    @State private var imageSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var pickPhoto = false
    
    @Binding var selectedImage: UIImage?
    @Binding var hideBottomSheet: Bool
    let deleteAvatarAction: (Bool)->()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            VStack(spacing: 40) {
                BottomSheetLineView()
                
                HStack {
                    Text(title)
                        .font(.poppinsBold(size: 28))
                        .foregroundStyle(Color.mainBlack)
                        .padding(.horizontal, 20)
                    Spacer()
                }
                
            }.padding(.top, 12)
            
            HStack(spacing: 12) {
                AddPhotoWidgetView(icon: .icCamera, title: "Camera") {
                    self.imageSource = .camera
                    self.pickPhoto = true
                }
                
                AddPhotoWidgetView(icon: .icGallery, title: "Gallery") {
                    self.imageSource = .photoLibrary
                    self.pickPhoto = true
                }
            }.frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
            
            Spacer()
            
            VStack(spacing: 8) {
                BlueButtonView(text: buttonText) {
                    self.deleteAvatarAction(true)
                }
                
                ClearButton(text: "Close") {
                    self.hideBottomSheet = false
                }
            }.padding([.horizontal, .bottom], 20)
            
        }.background(Color.mainWhite)
            .ignoresSafeArea(.container, edges: [.horizontal, .bottom])
            .sheet(isPresented: $pickPhoto) {
                ImagePickerView(sourceType: self.$imageSource) { image in
                    selectedImage = image
                }
                .ignoresSafeArea()
            }
    }
}

fileprivate struct AddPhotoWidgetView: View {
    let icon: ImageResource
    let title: String
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 12) {
                Spacer()
                Image(icon)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.mainBlack)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.poppinsRegular(size: 14))
                    .foregroundStyle(Color.mainBlack)
                    .lineLimit(1)
                Spacer()
                
            }.fixedSize(horizontal: false, vertical: true)
        }.padding(.vertical, 52)
            .background(Color.mainGray)
            .cornerRadius(8, corners: .allCorners)
    }
}
