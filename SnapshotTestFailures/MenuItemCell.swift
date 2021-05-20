//
//  MenuItemCell.swift
//
//  Created by Cronay on 23.04.21.
//

import UIKit

class MenuItemCell: UICollectionViewCell {
    let titleLabel = UILabel()
    let menuImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        menuImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(menuImageView)
        addSubview(titleLabel)
        contentView.leadingAnchor.constraint(equalTo: menuImageView.leadingAnchor, constant: -16).isActive = true
        contentView.trailingAnchor.constraint(equalTo: menuImageView.trailingAnchor, constant: 16).isActive = true
        menuImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        menuImageView.contentMode = .scaleAspectFit
        menuImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        titleLabel.textColor = .secondaryLabel
        titleLabel.numberOfLines = 2
        titleLabel.topAnchor.constraint(equalTo: menuImageView.bottomAnchor, constant: 4).isActive = true
        contentView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
