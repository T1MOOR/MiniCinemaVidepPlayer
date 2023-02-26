//
//  QueryTag.swift
//  MiniCinemaVideoPlayer
//
//  Created by Тимур Гарипов on 26.02.23.
//

import SwiftUI

struct QueryTag: View {
    var query: Query
    var isSelected: Bool
    
    
    var body: some View {
        Text(query.rawValue)
            .font(.caption)
            .bold()
            .foregroundColor(isSelected ? .black : .white)
            .padding(15)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
        
        
    }
}

struct QueryTag_Previews: PreviewProvider {
    static var previews: some View {
        QueryTag(query: Query.food, isSelected: true)
    }
}
