/// Path: Core/AppScreens/SetGameScreen/Components/AspectVGrid.swift
/// Role: Adaptive vertical grid that computes item width from geometry and aspect ratio

import SwiftUI

struct AspectVGrid<Item, ItemView>: View
where ItemView: View, Item: Identifiable {
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView

    // MARK: - Initilization
    init(
        items: [Item],
        aspectRatio: CGFloat,
        @ViewBuilder content: @escaping (Item) -> ItemView
    ) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }

    // MARK: - Body View
    var body: some View {
        aspectVGridView
    }

    // MARK: - Sub.Views
    private var aspectVGridView: some View {
        GeometryReader { geometry in
            let width: CGFloat = widthThatFits(
                itemCount: items.count,
                in: geometry.size,
                itemAspectRatio: aspectRatio
            )
            LazyVGrid(
                columns: [adaptiveGridItem(width: width)],
                spacing: SetGameTheme.cardGridContainerSpacing
            ) {
                ForEach(items) { item in
                    content(item).aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
        }
    }

    // MARK: - Private Methods
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = SetGameTheme.cardGridInterItemSpacing
        return gridItem
    }

    private func widthThatFits(
        itemCount: Int,
        in size: CGSize,
        itemAspectRatio: CGFloat
    ) -> CGFloat {
        var columnCount = SetGameTheme.cardGridInitialColumnCount
        var rowCount = itemCount
        if itemCount == 0 { return size.width }
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            if CGFloat(rowCount) * itemHeight < size.height {
                return itemWidth
            }
            columnCount += 1
            rowCount = (itemCount + columnCount + SetGameTheme.cardGridCeilAdjust) / columnCount
        } while columnCount < itemCount
        return size.width / CGFloat(columnCount)
    }
}
