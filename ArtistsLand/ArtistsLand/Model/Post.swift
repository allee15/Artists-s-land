//
//  Post.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 08.11.2024.
//

import Foundation

struct Post {
    let id: Int64
    let description: String
    let date: Date
    let artistName: String
    let artistId: Int64
    let artistAvatarUrl: String
    let nbOfLikes: Int64
    let postUrl: String
    let comments: [Comment]
}

struct Comment {
    let id: Int64
    let name: String
    let description: String
}

let postsMocked: [Post] = [
    Post(id: 1, description: "Cloudy day", date: Date(), artistName: "Ana", artistId: 1, artistAvatarUrl: "https://media.istockphoto.com/id/638756792/photo/beautiful-woman-posing-against-dark-background.jpg?s=612x612&w=0&k=20&c=AanwEr0pmrS-zhkVJEgAwxHKwnx14ywNh5dmzwbpyLk=", nbOfLikes: 23, postUrl: "https://media.istockphoto.com/id/148184555/vector/cloudscape.jpg?s=612x612&w=0&k=20&c=dWtNCwuEVeMEJnZn1kI-CuFVysHFpR_PSJs7JQWDajw=",
         comments: [Comment(id: 1, name: "Foarte frumos!", description: "kfsjngvkejfrbsdhjgknfewhrgnfuirejkhf")]),
    Post(id: 2, description: "Autumn days", date: Date(), artistName: "Michael", artistId: 1, artistAvatarUrl: "https://media.istockphoto.com/id/1300972574/photo/millennial-male-team-leader-organize-virtual-workshop-with-employees-online.jpg?s=612x612&w=0&k=20&c=uP9rKidKETywVil0dbvg_vAKyv2wjXMwWJDNPHzc_Ug=", nbOfLikes: 45, postUrl: "https://media.istockphoto.com/id/1353307239/vector/cabin-by-the-lake-vintage-oil-painting.jpg?s=612x612&w=0&k=20&c=L8WIfaFVClD3DohbPGRRcA7KWjVQMsX8-HTJW6I3g1g=",
         comments: [Comment(id: 2, name: "Interesant", description: "ewhrgnfuirejkhfewhrgnfuirejkhf")])
]
