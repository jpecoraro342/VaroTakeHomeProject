//
//  ViewController.swift
//  VaroMobileEngineeringProject
//
//  Created by Joseph Pecoraro on 8/3/23.
//

import UIKit

class NowPlayingVC: UIViewController {

    let nowPlayingViewModel = NowPlayingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
        setupCollectionView()
        setupViewModel()
    }

    func setupViewModel() {
        nowPlayingViewModel.onUpdate = {
            self.updateView()
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

    }

    @MainActor
    func updateView() {

    }
}

