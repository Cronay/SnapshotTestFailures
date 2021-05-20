//
//  MainUIComposer.swift
//
//  Created by Cronay on 17.05.21.
//

import UIKit

final class MenuUIComposer {
    private init() {}

    static func compose(with menuItems: [MenuItem]) -> MenuViewController {
        let viewController = MenuViewController(menuItems: menuItems)
        return viewController
    }
}
