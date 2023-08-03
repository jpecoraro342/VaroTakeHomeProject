//
//  ViewController.swift
//  VaroMobileEngineeringProject
//
//  Created by Joseph Pecoraro on 8/3/23.
//

import UIKit

class NowPlayingVC: UIViewController {
    
    let nowPlayingViewModel = NowPlayingViewModel()
    
    lazy var collectionView = {
        let margin = 20.0
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = margin
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
        setupCollectionView()
        setupViewModel()
    }
    
    func setupViewModel() {
        nowPlayingViewModel.onUpdate = {
            Task {
                self.updateView()
            }
        }
        
        nowPlayingViewModel.updateNowPlaying()
    }
    
    func setupView() {
        self.view.backgroundColor = .systemBackground
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "Now Playing"
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @MainActor
    func updateView() {
        self.collectionView.reloadData()
    }
}

extension NowPlayingVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Favorite
    }
}

extension NowPlayingVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlayingViewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell ?? MovieCollectionViewCell()
        
        cell.configureWith(movie: nowPlayingViewModel.getCellViewModel(at: indexPath))
        return cell
    }
}

extension NowPlayingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 225 + 30)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let spacing = spacing()

        return UIEdgeInsets(top: 20.0, left: spacing, bottom: 20.0, right: spacing)
    }

    private func spacing() -> Double {
        let width = Double(view.bounds.width - view.safeAreaInsets.left - view.safeAreaInsets.right)
        let minimumSpace = 10.0
        let numItemsInRow = Double(Int(width/(150.0 + minimumSpace)))

        let spacing = (width - (numItemsInRow * 150.0))/(numItemsInRow + 1)

        return spacing
    }
}

