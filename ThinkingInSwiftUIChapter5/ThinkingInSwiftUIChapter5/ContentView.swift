//
//  ContentView.swift
//  ThinkingInSwiftUIChapter5
//
//  Created by Nicholas Maccharoli on 2020/05/16.
//  Copyright © 2020 Nicholas Maccharoli. All rights reserved.
//

import SwiftUI

struct WidthPreference: PreferenceKey {
    static var defaultValue: [Int: CGFloat] = [:]
    
    static func reduce(value: inout [Int : CGFloat], nextValue: () -> [Int : CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: max)
    }
}

extension View {
    func widthPreference(column: Int) -> some View {
        background(GeometryReader {
            Color.clear.preference(key: WidthPreference.self, value: [column: $0.size.width])
        })
    }
}

struct Table<Moo: View>: View {
    @State private var columnWidths: [Int: CGFloat] = [:]
    var cells: [[Moo]]
    
    struct Selected: Equatable {
        let row: Int
        let col: Int
    }
    
    @State var selected: Selected?
    
    func cellFor(row: Int, column: Int) -> some View {
        Button( action: {
            self.selected = Selected(row: row, col: column)
        },
                label: { cells[row][column]
                    .foregroundColor(Color.black)
                    .widthPreference(column: column)
                    .frame(width: self.columnWidths[column], alignment: .leading)
                    .border(
                        selected == Selected(row: row, col: column) ? Color.red :  Color.clear
                    )
        })
    }
    
    var body: some View {
        VStack {
            ForEach(self.cells.indices) { row in
                HStack {
                    ForEach(self.cells[row].indices) { column in
                        self.cellFor(row: row, column: column)
                    }
                }
                .background(row.isMultiple(of: 2) ? Color(.systemBackground) : Color(.secondarySystemBackground))
            }
        }
        .onPreferenceChange(WidthPreference.self, perform: { self.columnWidths = $0 })
    }
}

struct ContentView: View {
    
    var cells = [
        [Text(""), Text("Monday").bold(), Text("Tuesday").bold(), Text("Wednesday").bold()],
        [Text("Berlin").bold(), Text("Cloudy"), Text("Mostly\nSunny"), Text("Sunny")],
        [Text("London").bold(), Text("Heavy Rain"), Text("Cloudy"), Text("Sunny")],
    ]
    
    var body: some View {
        Table(cells: cells)
            .font(Font.system(.body, design: .serif))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
