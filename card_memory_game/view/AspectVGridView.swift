//
//  AspectVGridView.swift
//  card_memory_game
//
//  Created by Enigma Kod on 27/05/2023.
//

import SwiftUI

struct AspectVGridView<Item, ItemView>: View where ItemView: View, Item: Identifiable {
    let item: [Item]
    let aspectRatio: CGFloat
    var context: (Item) -> ItemView
    
    init(item: [Item], aspectRatio: CGFloat, @ViewBuilder context: @escaping (Item) -> ItemView) {
        self.item = item
        self.aspectRatio = aspectRatio
        self.context = context
    }

    var body: some View {
        GeometryReader { geometry in
            let width: CGFloat = widthThatFits(
                itemCount: item.count,
                in: geometry.size,
                itemAspectRatio: aspectRatio
            )
            
            LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                ForEach(item) { item in
                    context(item).aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
        }
    }
    
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    private func widthThatFits(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount
        
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            
            columnCount += 1
            rowCount = (itemCount + (columnCount - 1)) / columnCount
            
        } while columnCount < itemCount
        
        if columnCount > itemCount {
            columnCount = itemCount
        }
        
        return floor(size.width / CGFloat(columnCount))
    }
}

// struct AspectVGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        AspectVGridView()
//    }
// }
