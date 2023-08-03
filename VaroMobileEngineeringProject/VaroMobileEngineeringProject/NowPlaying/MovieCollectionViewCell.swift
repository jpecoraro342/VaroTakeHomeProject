//
//  MovieCollectionViewCell.swift
//  VaroMobileEngineeringProject
//
//  Created by Joseph Pecoraro on 8/3/23.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    var movieViewModel : MovieCellViewModel?

    let imageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let titleLabel = {
        var titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        return titleLabel
    }()

    let favoriteButton = {
        var favoriteButton = UIButton()
        return favoriteButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        movieViewModel = nil
        imageView.image = nil // TODO: Cancel in flight image request
        titleLabel.text = nil
    }

    // Layout
    private func setupConstraints() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])

        contentView.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        contentView.bringSubviewToFront(favoriteButton)
    }
}

extension MovieCollectionViewCell {
    func configureWith(movie: MovieCellViewModel) {
        movieViewModel = movie

        titleLabel.text = movie.title
        if movie.isFavorite {
            favoriteButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        }
        fetchImage(url: movie.posterUrl, id: movie.id)
    }

    private func fetchImage(url: URL, id: String) {
        Task.detached { [weak self] in
            guard let self = self else { return }

            if let image = await ImageDataService.shared.getImage(url: url) {
                await updateImage(image: image, id: id)
            }
        }
    }

    @MainActor
    private func updateImage(image: UIImage, id: String) {
        if id == self.movieViewModel?.id {
            self.imageView.image = image
        }
    }

    @objc func toggleFavorite() {
        guard let movie = movieViewModel else { return }
        movie.toggleFavorite(movie.id)
    }
}
