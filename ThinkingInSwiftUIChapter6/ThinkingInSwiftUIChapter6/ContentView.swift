//
//  ContentView.swift
//  ThinkingInSwiftUIChapter6
//
//  Created by Nicholas Maccharoli on 2020/05/19.
//  Copyright © 2020 Nicholas Maccharoli. All rights reserved.
//

import SwiftUI


struct Bounce: AnimatableModifier {
    var times: CGFloat = 0
    var amplitude: CGFloat = 2
    
    var animatableData: CGFloat {
        get { times }
        set { times = newValue }
    }
    
    func body(content: Content) -> some View {
        return content.scaleEffect(1.0 + abs(sin(times * .pi) ) * amplitude)
    }
}

extension View {
    func bounce(times: Int) -> some View {
        return modifier(Bounce(times: CGFloat(times)))
    }
}

struct ContentView: View {
    @State var taps: Int = 0
    var body: some View {
        Button("Tap Me!") {
            withAnimation(Animation.linear(duration: 0.75)) {
                self.taps += 1
            }
        }
        .padding(10.0)
        .accentColor(Color.white)
        .background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 8.0))
       
        .bounce(times: taps)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
