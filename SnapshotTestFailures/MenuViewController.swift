//
//  MenuViewController.swift
//
//  Created by Yannic Borgfeld on 15.05.19.
//

import UIKit

class MenuViewController: UICollectionViewController {
    private var menuItems = [MenuItem]()

    convenience init(menuItems: [MenuItem]) {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = .init(top: 40, leading: 0, bottom: 0, trailing: 0)
        let layout = UICollectionViewCompositionalLayout(section: section)
        self.init(collectionViewLayout: layout)
        self.menuItems = menuItems
    }

    override func viewDidLoad() {
        collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: "MenuItemCell")
        collectionView.backgroundColor = .systemBackground
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        menuItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = menuItems[indexPath.item]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
        cell.titleLabel.text = model.title
        cell.menuImageView.image = model.image
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = menuItems[indexPath.item]
        model.action()
    }
}

