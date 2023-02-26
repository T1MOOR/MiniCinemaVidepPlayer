//
//  LogoApp.swift
//  MiniCinemaVideoPlayer
//
//  Created by Тимур Гарипов on 26.02.23.
//

import SwiftUI

struct LogoApp: View {

    var body: some View {
        VStack {
            Text("MINI CINEMA")
    //            .font(.largeTitle)
             .font(.custom("Bodoni 72 Oldstyle Book", size: 30))
         .bold()
         .foregroundColor(.black)
            Text("YOUR PERSONAL THEATER")
    //            .font(.largeTitle)
             .font(.custom("Bodoni 72 Oldstyle Book", size: 10))
             .foregroundColor(.black)
        }

    }
}

struct LogoApp_Previews: PreviewProvider {
    static var previews: some View {
        LogoApp()
    }
}
