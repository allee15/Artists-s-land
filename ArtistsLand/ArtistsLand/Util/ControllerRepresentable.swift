//
//  ControllerRepresentable.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import UIKit
import SwiftUI

struct ControllerRepresentable: UIViewControllerRepresentable {
    let controller: UIViewController
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}

