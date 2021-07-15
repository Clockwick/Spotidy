//
//  CategoryCollectionViewCell.swift
//  Spotify
//
//  Created by Paratthakorn Sribunyong on 15/7/2564 BE.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
//    private let colors: [UIColor] = [
//        .systemPink,
//        .systemPurple,
//        .systemRed,
//        .systemBlue,
//        .systemOrange,
//        .systemGreen
//    ]
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        label.frame = CGRect(
            x: 70,
            y: contentView.height / 2,
            width: contentView.width - 140,
            height: contentView.height / 2
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }
    
    func configure(with viewModel: CategoryCollectionViewCellViewModel) {
        label.text = viewModel.title
        imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
//        contentView.backgroundColor = colors.randomElement()
    }
    
}
