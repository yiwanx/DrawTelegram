//
// Created by Ivan Petukhov on 13/10/2022.
//

import UIKit


class PhotoCollectionCell: UICollectionViewCell {

    var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.constraint(to: contentView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

extension UICollectionViewCell {
    static var reuseId: String { .init(reflecting: Self.self) }
}