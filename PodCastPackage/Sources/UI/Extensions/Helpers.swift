//
//  ProfileHelpers.swift
//  Example
//
//  Created by Alisa Mylnikova on 11/11/2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import Kingfisher

public struct HireButtonStyle: ButtonStyle {

    var foreground = Color.white

    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .overlay(configuration.label.foregroundColor(foreground))
    }
}

public struct VisualEffectView: UIViewRepresentable {

    var effect: UIVisualEffect?

   public init(effect: UIVisualEffect? = nil) {
        self.effect = effect
   }
    
    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    public func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

public extension View {

    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

public struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


public struct CircleButtonStyle: ButtonStyle {

    var imageName: String
    var foreground = Color.white
    var background = Color.black
    var width: CGFloat = 40
    var height: CGFloat = 40

    public init(imageName: String,background: Color = Color.black ) {
        self.imageName = imageName
        self.background = background
    }

    public func makeBody(configuration: Configuration) -> some View {
        Circle()
            .fill(background.opacity(0.5))
            .overlay(Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(foreground)
                        .padding(12))
            .frame(width: width, height: height)
    }
}



public struct FillImage: View {
    let url: URL?
    @Environment(\.redactionReasons) var redactionReasons
    
    public init(_ url: URL?) {
        self.url = url
    }
    
    public var body: some View {
        if redactionReasons.isEmpty {
            KFAnimatedImage(url)
                .placeholder { _ in
                    Color.gray.opacity(0.8)
                }
                .aspectRatio(contentMode: .fill)
        }  else {
            Color.gray.opacity(0.8)
       }
    }
}



public struct ViewDidLoadModifier: ViewModifier {
    @State private var viewDidLoad = false
    let action: (() -> Void)?
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidLoad == false {
                    viewDidLoad = true
                    action?()
                }
            }
    }
}

public extension View {
    func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(ViewDidLoadModifier(action: action))
    }
}

