//
//  MenuUISnapshotTests.swift
//
//  Created by Cronay on 03.05.21.
//

import XCTest
@testable import SnapshotTestFailures

class MenuUISnapshotTests: XCTestCase {

    func test_menuUI_withNoMenuItems() {
        let sut = makeSUT(menuItems: [])

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "EMPTY_MENU_UI_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "EMPTY_MENU_UI_DARK")
    }

    func test_menuUI_withMenuItem() {
        let sut = makeSUT(menuItems: [
            .init(title: "item0", image: UIImage.make(with: .red), action: {}),
            .init(title: "item1", image: UIImage.make(with: .blue), action: {}),
            .init(title: "item2", image: UIImage.make(with: .brown), action: {}),
            .init(title: "item3", image: UIImage.make(with: .cyan), action: {}),
            .init(title: "verylongtitleforitem4 withalinebreakitem4", image: UIImage.make(with: .red), action: {}),
            .init(title: "item5", image: UIImage.make(with: .blue), action: {}),
            .init(title: "item6", image: UIImage.make(with: .brown), action: {}),
            .init(title: "item7", image: UIImage.make(with: .cyan), action: {}),
        ])

        let navController = UINavigationController(rootViewController: sut)
        navController.navigationBar.barTintColor = .blue
        navController.navigationBar.isTranslucent = false

        navController.loadViewIfNeeded()

        assert(snapshot: navController.snapshot(for: .iPhone8(style: .light)), named: "MENU_UI_LIGHT")
        assert(snapshot: navController.snapshot(for: .iPhone8(style: .dark)), named: "MENU_UI_DARK")
    }

    // MARK: - Helpers
    private func makeSUT(menuItems: [MenuItem]) -> MenuViewController {
        return MenuUIComposer.compose(with: menuItems)
    }
}

extension UIImage {
    static func make(with color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

