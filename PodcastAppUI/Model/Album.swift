//
//  Album.swift
//  PodcastAppUI
//
//  Created by Shameem Reza on 22/3/22.
//

import SwiftUI

// MARK: - Album Data Model

struct Album: Identifiable {
    var id = UUID().uuidString
    var albumName: String
    var albumImage: String
    var isLiked: Bool = false
}

// MARK: - TOP ALBUM
var stackAlbums: [Album] = [
    Album(albumName: "Map of the Soul: 7", albumImage: "album1"),
    Album(albumName: "Jail Theke Bolchhi", albumImage: "album3"),
    Album(albumName: "Kiss & Tell", albumImage: "album7"),
    Album(albumName: "Jal Pari", albumImage: "album6"),
    Album(albumName: "A Little Bit of Your Heart", albumImage: "album9"),
]

// MARK: - MUSIC LIST
var albums: [Album] = [
    Album(albumName: "This Magic Moment", albumImage: "album9", isLiked: true),
    Album(albumName: "What Else Can I Do?", albumImage: "album1"),
    Album(albumName: "Do We Have A Problem?", albumImage: "album2", isLiked: true),
    Album(albumName: "Everything or Nothing", albumImage: "album3", isLiked: true),
    Album(albumName: "The Future Is Now", albumImage: "album4"),
    Album(albumName: "Never Looking Back", albumImage: "album5", isLiked: true),
    Album(albumName: "Easy On Me", albumImage: "album6"),
    Album(albumName: "All the Way Up", albumImage: "album7", isLiked: true),
    Album(albumName: "Love You Better", albumImage: "album8"),
    Album(albumName: "Love Me Like You Do", albumImage: "album10", isLiked: true),

]
