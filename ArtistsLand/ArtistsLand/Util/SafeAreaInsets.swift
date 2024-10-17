//
//  SafeAreaInsets.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import Foundation
import SwiftUI

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero).insets
    }
}

extension EnvironmentValues {
    
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

public var SafeAreaInsets: EdgeInsets {
    UIApplication.shared.keyWindow?.safeAreaInsets.insets ?? EdgeInsets()
}

