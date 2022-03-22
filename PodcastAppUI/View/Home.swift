//
//  Home.swift
//  PodcastAppUI
//
//  Created by Shameem Reza on 22/3/22.
//

import SwiftUI

struct Home: View {
    
    @State var expandCards: Bool = false //TOP ALBUM ANIMATION PROPERTIES
    @State var currentCard: Album?
    @State var showDetail: Bool = false
    @State var currentIndex: Int = -1 // STORING CARD TO ANIMATE
    @Namespace var animation // HERO ANIMATION
    @State var cardSize: CGSize = .zero // CURRENT ALBUM IMAGE SIZE
    @State var animateSingleView: Bool = false // SINGLE VIEW ANIMATION PROPERTIES
    @State var rotateCards: Bool = false
    @State var showDetailContent: Bool = false
    
    var body: some View {
        // MARK: - BODY
        VStack {
            // MARK: - APP BAR
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.title)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "gearshape")
                        .font(.title)
                }
            } // END APP BAR
            .overlay(content: {
                Text("Podcaster UI")
                    .font(.title2)
                    .fontWeight(.semibold)
            })
            .foregroundColor(.black)
            .padding(.horizontal
            )
            
            // MARK: - TOP ALBUM VIEW
            GeometryReader{proxy in
                
                let size = proxy.size
                
                StackPlayerView(size: size)
                    .frame(width: size.width, height: size.height, alignment: .center)
            } // END TOP ALBUM
            
            // MARK: - RECENTLY PLAYED
            VStack(alignment: .leading, spacing: 15) {
                Text("Recently Played")
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(albums) {album in
                            Image(album.albumImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 95, height: 95)
                                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        }
                    }
                    .padding([.horizontal, .bottom])
                }
                
            } // END RECENTLY PLAYED
        } // END BODY
        .padding(.vertical)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background{
            Color("colorBG")
                .ignoresSafeArea()
        }
        // MARK: - SINGLE VIEW
        .overlay {
            if let currentCard = currentCard, showDetail {
                ZStack {
                    Color("colorBG")
                        .ignoresSafeArea()
                    SingleView(currentCard: currentCard)
                }
            }
        } // END DETAIL VIEW
    }
    
    // MARK: - TOP LIST VIEW
    @ViewBuilder
    func StackPlayerView(size: CGSize) -> some View{
        
        let offsetHeight = size.height * 0.1
        
        ZStack {
            ForEach(stackAlbums.reversed()) {album in
                
                let index = getIndex(album: album)
                let imageSize = (size.width - (CGFloat(index) * 20))
                
                
                Image(album.albumImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageSize / 2, height: imageSize / 2)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    // MARK: ROTATION
                    .rotation3DEffect(.init(degrees: expandCards && currentIndex != index ? -10 : 0), axis: (x: 1, y: 0, z: 0), anchor: .center, anchorZ: 1, perspective: 1)
                    .rotation3DEffect(.init(degrees: expandCards && currentIndex == index && rotateCards ? 360 : 0), axis: (x: 1, y: 0, z: 0), anchor: .center, anchorZ: 1, perspective: 1)
                    .matchedGeometryEffect(id: album.id, in: animation)
                    .offset(y: CGFloat(index) * -20)
                    .offset(y: expandCards ? -CGFloat(index) * offsetHeight : 0)
                    .onTapGesture {
                        if expandCards {
                            // MARK: - SELECT CURRENT ALBUM
                            withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8)) {
                                cardSize = CGSize(width: imageSize / 2, height: imageSize / 2)
                                currentCard = album
                                currentIndex = index
                                showDetail = true
                                rotateCards = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation(.spring()) {
                                        animateSingleView = true
                                    }
                                }
                            }
                        } else {
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                expandCards = true
                            }
                        } // END CONDITION
                    } //END GESTURE
                    .offset(y: showDetail && currentIndex != index ? size.height * (currentIndex < index ? -1 : 1) : 0)
            } // END LOOP
        } // END ZSTACK
        .offset(y: expandCards ? offsetHeight * 2 : 0)
        .frame(width: size.width, height: size.height)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                expandCards.toggle()
            }
        }
    } // END TOP LIST VIEW
    
    // MARK: SINGLE VIEW
    @ViewBuilder
    func SingleView(currentCard: Album)-> some View {
        VStack(spacing: 0) {
            Button {
                rotateCards = false
                withAnimation {
                    showDetailContent = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8)) {
                        self.currentIndex = -1
                        self.currentCard = nil
                        showDetail = false
                        animateSingleView = false
                    }
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.black)
            } // END BACK BUTTON
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.horizontal, .top])
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 25) {
                    Image(currentCard.albumImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: cardSize.width, height: cardSize.height)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        // MARK: - INITIAL ROTATION
                        .rotation3DEffect(.init(degrees: showDetail && rotateCards ? -180 : 0), axis: (x: 1, y: 0, z: 0), anchor: .center, anchorZ: 1, perspective: 1)
                        .rotation3DEffect(.init(degrees: animateSingleView && rotateCards ? 180 : 0), axis: (x: 1, y: 0, z: 0), anchor: .center, anchorZ: 1, perspective: 1)
                        .matchedGeometryEffect(id: currentCard.id, in: animation)
                        .padding(.top, 50)
                    
                    VStack(spacing: 20) {
                        Text(currentCard.albumName)
                            .font(.title2.bold())
                            .padding(.top, 10)
                        
                        HStack(spacing: 50) {
                            Button {
                                
                            } label: {
                                Image(systemName: "shuffle")
                                    .font(.title2)
                            }
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "pause.fill")
                                    .font(.title3)
                                    .frame(width: 55, height: 55)
                                    .background {
                                        Circle()
                                            .fill(Color("colorPlay"))
                                    }
                                    .foregroundColor(.white)
                            }
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "arrow.2.squarepath")
                                    .font(.title2)
                            }
                        } // END PLAYER CONTROL
                        .foregroundColor(.black)
                        .padding(.top, 10)
                        
                        Text("Upcoming Track")
                            .font(.title2.bold())
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(albums){album in
                            TrackCardView(album: album)
                        } // END TRACK LIST
                    } // END ALBUM NAME AND PLAYER ICON
                    .padding(.horizontal)
                    .offset(y: showDetailContent ? 0 : 300)
                    .opacity(showDetailContent ? 1 : 0)
                } //END ALBUM IMAGE
                .frame(maxWidth: .infinity)
            }
        } // END VSTACK
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeInOut) {
                    showDetailContent = true
                }
            }
        }
    } // END SINGLE VIEW
    
    // MARK: - TRACK CARD VIEW
    @ViewBuilder
    func TrackCardView(album: Album)-> some View {
        HStack(spacing: 12) {
            Image(album.albumImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 55, height: 55)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            VStack(alignment: .leading, spacing: 8) {
                Text(album.albumName)
                    .fontWeight(.semibold)
                Label {
                    Text("120,230,333")
                } icon: {
                    Image(systemName: "headphones.circle")
                }
                .font(.caption)
                .foregroundColor(.gray)
            } // END VSTACK
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                
            } label: {
                Image(systemName: album.isLiked ? "heart.circle.fill" : "heart.circle")
                    .font(.title3)
                    .foregroundColor(album.isLiked ? .pink : .gray)
            } // END LIKED
            
            Button {
                
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(.gray)
            } // END SETTING
        }
    }
    
    // MARK: - ALBUM INDEX
    func getIndex(album: Album)-> Int {
        return stackAlbums.firstIndex {currentAlbum in
            return album.id == currentAlbum.id
        } ?? 0
    } // END ALBUM INDEX
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
