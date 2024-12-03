//
//  ConversationScreen.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 07.11.2024.
//

import SwiftUI
import Kingfisher

struct ConversationScreen: View {
    @StateObject var viewModel: ConversationViewModel
    @EnvironmentObject private var navigation: Navigation
    private let mainNavigation = EnvironmentObjects.navigation
    
    @State private var showSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            LeftRightNavBarView(chat: viewModel.chat) {
                let modal = ModalChooseOptionView(title: "Are you sure you want to delete this chat?",
                                                  description: "This action will take you out of this chat and you will have to search again this person.",
                                                  topButtonText: "Delete chat",
                                                  bottomButtonText: "Stay") {
                    viewModel.deleteChat()
                } onBottomButtonTapped: {
                    navigation.dismissModal(animated: true, completion: nil)
                }
                
                navigation.presentPopup(modal.asDestination(), animated: true, completion: nil)
                
            } chatAction: {
                let vm = ArtistProfileViewModel(artistId: viewModel.chat.secondParticipantId)
                navigation.push(ArtistProfileScreen(viewModel: vm).asDestination(), animated: true)
            }.padding(.horizontal, 16)
            
            ScrollViewReader { scrollProxy in
                ScrollView(showsIndicators: false) {
                    ForEach(viewModel.messages, id: \.message) { message in
                        
                        let wasSentByMe = message.senderId == viewModel.user.id
                        
                        VStack(alignment: .leading, spacing: 8) {
                            if let url = message.fileUrl, !url.isEmpty {
                                Button {
                                    mainNavigation?.push(ZoomImageScreen(imageToZoom: url).asDestination(), animated: true)
                                } label: {
                                    KFImage(URL(string: "file://\(url)"))
                                        .resizable()
                                        .placeholder {
                                            Image(.imgPlaceholder)
                                                .resizable()
                                        }
                                        .centerCropped()
                                        .aspectRatio(1, contentMode: .fill)
                                        .frame(maxWidth: .infinity)
                                        .padding(.bottom, 4)
                                }
                            }
                            
                            Text("\(message.message)")
                                .font(.poppinsRegular(size: 16))
                                .foregroundColor(Color.mainBlack)
                                .multilineTextAlignment(.leading)
                            
                            Text("\(message.createdAt)")
                                .font(.poppinsSemiBold(size: 10))
                                .foregroundColor(Color.contentSecondary)
                        }.padding(.all, 12)
                            .background(wasSentByMe ? Color.simpleBlue.opacity(0.3) : Color.mainGray)
                            .cornerRadius(8, corners: .allCorners)
                            .frame(width: UIScreen.main.bounds.width * 0.8, alignment: wasSentByMe ? .trailing : .leading)
                            .id(message.message)
                            .onChange(of: viewModel.messages.count) { _, _ in
                                scrollProxy.scrollTo(viewModel.messages.last?.message)
                            }.padding(.bottom, 12)
                    }
                    
                }.padding(.vertical, 12)
            }
            
            Rectangle()
                .frame(height: 1)
                .padding(.horizontal, 2)
                .foregroundColor(Color.contentSecondary)
            
            SendMessageField(text: $viewModel.message,
                             placeHolder: "Type your message",
                             icon: .icSend,
                             iconSecond: .icAddPhoto) {
                viewModel.sendMessage()
            } actionSecond: {
                self.showSheet = true
            }.padding(.bottom, 28)
                .padding(.horizontal, 12)
            
        }.background(Color.mainWhite)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: [.horizontal, .bottom])
            .sheet(isPresented: $showSheet) {
                AddProfilePhotoView(title: "Send image in chat",
                                    buttonText: "Send image",
                                    selectedImage: $viewModel.image,
                                    hideBottomSheet: $showSheet) { deleteAvatar in
                    viewModel.sendMessage()
                }
            }
            .onReceive(viewModel.eventSubject) { event in
                switch event {
                case .imageSent:
                    self.showSheet = false
                    
                case .failed:
                    let toast = Toast(text: "An error has occured. Please try again!", textColor: Color.lightRed)
                    ToastManager.instance.show(toast)
                    
                case .chatDeleted:
                    navigation.dismissModal(animated: true, completion: nil)
                    navigation.pop(animated: true)
                    TabBarCoordinator.instance.shouldGetChats = true
                }
            }
    }
}

struct SendMessageField: View {
    @Binding var text: String
    let placeHolder: String
    var colors: (bgColor: Color, borderColor: Color, placeholderForeground: Color) = (.mainWhite, .mainWhite, .mainBlack)
    let icon: SwiftUI.ImageResource
    var iconSecond: SwiftUI.ImageResource?
    let action: () -> ()
    var actionSecond: (() -> ())?
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                HStack {
                    if $text.wrappedValue.isEmpty {
                        Text(placeHolder)
                            .foregroundColor(colors.placeholderForeground)
                            .font(.poppinsRegular(size: 14))
                            .multilineTextAlignment(.leading)
                    } else {
                        Text(placeHolder)
                            .foregroundColor(colors.placeholderForeground)
                            .font(.poppinsRegular(size: 14))
                            .scaleEffect(0.75, anchor: .leading)
                            .offset(y: -12)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                    
                    Spacer()
                }.padding(.horizontal, 16)
                
                TextField(text: $text) {
                }.foregroundColor(.mainBlack)
                    .font(.poppinsRegular(size: 14))
                    .padding(.leading, 16)
                    .offset(y: $text.wrappedValue.isEmpty ? 0 : 4 )
                    .padding(.trailing, 16)
                
                HStack(spacing: 16) {
                    Spacer()
                    Button {
                        if !text.isEmpty {
                            action()
                        }
                    } label: {
                        Image(icon)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(Color.mainBlack)
                            .frame(width: 24, height: 24)
                    }
                    
                    if let actionSecond = actionSecond, let iconSecond = iconSecond {
                        Button {
                            actionSecond()
                        } label: {
                            Image(iconSecond)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(Color.mainBlack)
                                .frame(width: 24, height: 24)
                        }
                    }
                } .padding(.horizontal, 20)
            }
            .frame(height: 54)
            .background(Color.mainWhite)
        }
    }
}
